import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import Json.Decode as Json
import Debug exposing (..)

type Action = NoOp | ClickIndex String

initialSeed = Random.initialSeed 1234

type alias Model =
  { numbers : List String
  , randomNumber : (Random.Seed, String)
  , lastClick : String
  , points : Int
  }


initialModel : Model
initialModel =
   { numbers = List.map toString [1..10]
   , randomNumber = (initialSeed, toString <| Random.generate (Random.int 0 10) initialSeed)
   , lastClick = ""
   , points = 0
   }


inbox : Signal.Mailbox String
inbox =
  Signal.mailbox ""


indexMessage : Signal String
indexMessage =
  inbox.signal


upperView : String -> Html
upperView indexToClick =
  div [ ]
    [ p [ ]
        [ text ("Click index: " ++ indexToClick) ]
    ]


singleColorView : String -> Html
singleColorView index =
  a
    [ href "#"
    , onClick numberInbox.address (ClickIndex index)
    , attribute "data-index" index
    , style [ ("background", "blue" ), ("padding", "20px"), ("margin", "10px"), ("color", "white") ]
    ]
    [ text index ]


view : Signal.Address Action -> Model -> Html
view  action model =
  div [ style [("margin", "50px")]]
    [ ul [ style [("margin-bottom", "50px")] ]
        (List.map singleColorView (List.map toString [1..10]))
    , text ("Number to click was: " ++ snd model.randomNumber)
    , text ("Index choosen was:  " ++ model.lastClick)
    ]


model : Signal Model
model =
  Signal.foldp update initialModel actions

update : Action -> Model -> Model
update action model =
  case action of
    NoOp
      -> model
    ClickIndex index
      -> { model | lastClick = index }

numberInbox : Signal.Mailbox Action
numberInbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  numberInbox.signal


main : Signal Html
main =
  Signal.map (view numberInbox.address) model
