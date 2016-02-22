import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import Json.Decode as Json
import Debug exposing (..)
import Time exposing (..)

import Model exposing (..)

type Action = NoOp | Tick | ClickIndex String


ticks : Signal Action
ticks = Signal.map (\_ -> Tick) (Time.fps 1)


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
    , p [ ]
        [ text ("Timer " ++ toString model.timer) ]
    , text ("Number to click was: " ++ (snd model.randomNumber))
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
    Tick
      -> { model | timer = model.timer - 1 }
    ClickIndex index
      -> { model | lastClick = index }


numberInbox : Signal.Mailbox Action
numberInbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  Signal.merge numberInbox.signal ticks


main : Signal Html
main =
  Signal.map (view numberInbox.address) model
