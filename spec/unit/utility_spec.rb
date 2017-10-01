require 'spec_helper'

RSpec.describe 'Utility Methods' do
  context 'to_snake_case' do
    context 'PersonController' do
      it {
        expect('PersonController'.to_snake_case).to eq 'person_controller'
      }
    end

    context 'Person' do
      it { expect('Person'.to_snake_case).to eq 'person' }
    end

    context 'Todo::Person' do
      it {
        expect('Todo::Person'.to_snake_case).to eq 'todo/person'
      }
    end

    context 'PERSONController' do
      it {
        expect('PERSONController'.to_snake_case).to eq 'person_controller'
      }
    end

    context 'Person8Controller' do
      it {
        expect('Person8Controller'.to_snake_case).to eq 'person8_controller'
      }
    end

    context 'personcontroller' do
      it {
        expect('personcontroller'.to_snake_case).to eq 'personcontroller'
      }
    end

    context 'person' do
      it { expect('person'.to_snake_case).to eq 'person' }
    end
  end
  context '#camelize' do
    context 'person_controller' do
      it {
        expect('person_controller'.camelize).to eq 'PersonController'
      }
    end
    context 'person__todo_app' do
      it {
        expect('person__todo_app'.camelize).to eq 'PersonTodoApp'
      }
    end
    context 'person' do
      it {
        expect('person'.camelize).to eq 'Person'
      }
    end
  end
end
