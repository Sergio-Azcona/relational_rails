require 'rails_helper'

RSpec.describe "Director_Films Index ('/directorss/:director_id/films') Page" do
  before(:each) do 
    @c_eastwood = Director.create!(name: 'Clint Eastwood',best_director_oscars: 2 ,multiple_best_director_nominations: true)
    @k_bigelow = Director.create!(name: 'Kathryn Bigelow',best_director_oscars: 1,multiple_best_director_nominations: false)
    @s_kubrick = Director.create!(name: 'Stanley Kubrick',best_director_oscars: 0,multiple_best_director_nominations: true)
    @s_spielberg = Director.create!(name: 'Steven Spielberg',best_director_oscars: 2 ,multiple_best_director_nominations: true)
    
    @million_dollar_baby = @c_eastwood.films.create!(name:'Million Dollar Baby', release_year: 2004, best_picture_oscar: true)
    @mystic_river = @c_eastwood.films.create!(name:'Mystic River', release_year: 2003, best_picture_oscar: false)
    @perfect_world = @c_eastwood.films.create!(name:'A Perfect World', release_year: 1993, best_picture_oscar: false)
    @true_crime = @c_eastwood.films.create!(name:'True Crime', release_year: 1999, best_picture_oscar: false)
    @unforgiven = @c_eastwood.films.create!(name:'Unforgiven', release_year: 1992, best_picture_oscar: true)
    
    @hurt_locker = @k_bigelow.films.create!(name:'The Hurt Locker', release_year: 2008, best_picture_oscar: true)
    @loveless = @k_bigelow.films.create!(name:'The Loveless', release_year: 1981, best_picture_oscar: false)
    @zero_dark_thirty = @k_bigelow.films.create!(name:'Zero Dark Thirty', release_year: 2012, best_picture_oscar: false)
    
    @eyes_wide_shut = @s_kubrick.films.create!(name:'Eyes Wide Shut', release_year: 1999, best_picture_oscar: false)
    @fear_and_desire = @s_kubrick.films.create!(name:'Fear and Desire', release_year: 1952, best_picture_oscar: false)
    @clockwork_orange = @s_kubrick.films.create!(name:'A Clockwork Orange', release_year: 1971, best_picture_oscar: false)
    
    @firelight = @s_spielberg.films.create!(name:'Firelight', release_year: 1964, best_picture_oscar: false)
    @jurassic_park = @s_spielberg.films.create!(name:"Jurassic Park", release_year: 1993, best_picture_oscar: false)
    @schindlers_list = @s_spielberg.films.create!(name:"Schindler's List", release_year: 1993, best_picture_oscar: true)
  
  end
  
  describe 'User Story 5' do
    it "displays each film that is associated with that director with each film's attributes" do
      visit ("/directors/#{@c_eastwood.id}/films")
      expect(page).to_not have_content(@s_spielberg.name)
      expect(page).to have_content(@c_eastwood.name)
      
      expect(page).to have_content(@million_dollar_baby.name)
      expect(page).to have_content(@mystic_river.release_year) 
      expect(page).to have_content(@true_crime.best_picture_oscar)
      # save_and_open_page
      within("#director-film-attributes-#{@unforgiven.id}")do
        expect(page).to_not have_content(@million_dollar_baby.name)
        expect(page).to_not have_content(@mystic_river.release_year) 
        expect(page).to_not have_content(@true_crime.best_picture_oscar)

        expect(page).to have_content(@unforgiven.name)
        expect(page).to have_content(@unforgiven.release_year) 
        expect(page).to have_content(@unforgiven.best_picture_oscar)
      end
    end
  end

  describe 'Story 16, Sort Films Alphabetical by name' do
    it 'displays director films sort alphabetical by name if the sort link selected' do
      visit ("/directors/#{@s_kubrick.id}/films")
      
      expect(page).to have_content('Sort Films A to Z')
      click_link ('Sort Films A to Z')
      
      expect(@s_kubrick.ordered_alphabetical).to_not eq([@eyes_wide_shut,@clockwork_orange,@fear_and_desire])     
      expect(@s_kubrick.ordered_alphabetical).to_not eq([@eyes_wide_shut,@fear_and_desire,@clockwork_orange])
      
      expect(@s_kubrick.ordered_alphabetical).to eq([@clockwork_orange,@eyes_wide_shut,@fear_and_desire])
    end
  end

  describe 'User Story 18, film Update From film Index Page' do
    describe 'has a link to edit that film next to every film' do
     it "takes user to that specific film's edit page" do
      visit ("/directors/#{@c_eastwood.id}/films")

      expect(page).to have_link("#{@mystic_river.name}")
      expect(page).to have_link("Update Film #{@perfect_world.name}") 

        within("#director-film-attributes-#{@million_dollar_baby.id}")do
          expect(page).to_not have_link("#{@true_crime.name}")
          expect(page).to_not have_link("Update film #{@unforgiven.name}")          
        
          expect(page).to have_link("#{@million_dollar_baby.name}")
          expect(page).to have_link("Update Film #{@million_dollar_baby.name}")
        end

      click_link("Update Film #{@million_dollar_baby.name}")

      expect(current_path).to_not eq(films_path)
      expect(current_path).to_not eq("/films/#{@mystic_river.id}/edit")
      expect(current_path).to eq("/films/#{@million_dollar_baby.id}/edit")
      end
    end
  end
end