## Fish Friends
## Last Updated: 2/4/25 by William Duprey
## Autoload Enums
## - This autoload script contains all of the enumerations 
##   used for the game in a nice, big, globally accessible file

extends Node

## Enumeration for the types of water, used by tanks to determine
## which type of water they hold, and used by marine life (fish and plants)
## to determine which types of water they can live in.
## - Some fish like salmon and eels, and plants like algae can tolerate 
##   fresh and salt water, so I made the "Any" type for them. 
##   Tanks should not use this value, since that's not how water works. 
## - Each type of water is defined using binary so that it is clear
##   that the "Any" type is a union of all the other values. 
enum WaterType
{ 
	Fresh     = 0b0001, # 1 
	Brackish  = 0b0010, # 2
	Salt      = 0b0100, # 4
	Any       = 0b0111  # 7
}

enum FishSpecies
{
	Guppy,
	Clownfish
}

enum PlantSpecies
{
	Guppygrass,
	Anemone
}

func get_species_name(species_value: int) -> String:
	match species_value:
		0: return "Guppy"
		1: return "ClownFish"
		_: return "Unkown"
		
