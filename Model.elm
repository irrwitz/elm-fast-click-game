module Model where

import Random
import Debug

initialSeed = Random.initialSeed 1234

type alias Model =
  { numbers : List String
  , randomNumber : (Random.Seed, String)
  , lastClick : String
  , points : Int
  , timer : Int
  }


initialModel : Model
initialModel =
  let
    firstRandomNumber = Random.generate (Random.int 0 10) initialSeed
  in
   { numbers = List.map toString [1..10]
   , randomNumber = (initialSeed, toString firstRandomNumber)
   , lastClick = ""
   , points = 0
   , timer = 30
   }

