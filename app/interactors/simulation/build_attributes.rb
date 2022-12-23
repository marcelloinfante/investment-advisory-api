class Simulation::BuildAttributes
  include Interactor::Organizer

  organize Simulation::ValidateAttributes, Simulation::FormatAttributes, Simulation::CalculateAttributes
end