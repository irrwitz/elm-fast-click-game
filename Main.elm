import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Array
import Json.Decode as Json
import Debug exposing (..)


inbox : Signal.Mailbox String
inbox =
  Signal.mailbox ""


indexMessage : Signal String
indexMessage =
  inbox.signal


upperView : String -> Html
upperView colorToFind =
  div [ ]
    [ p [ ]
        [ text ("Click index: " ++ colorToFind) ]
    ]


singleColorView : String -> Html
singleColorView index =
  a
    [ href "#"
    , onClick inbox.address index
    , attribute "data-index" index
    , style [ ("background", "blue" ), ("padding", "20px"), ("margin", "10px"), ("color", "white") ]
    ]
    [ text index ]


view :  String -> Html
view  indexMessage =
  div [ style [("margin", "50px")]]
    [ ul [ style [("margin-bottom", "50px")] ]
        (List.map singleColorView (List.map toString [1..10]))
    , text ("Index choosen was:  " ++ indexMessage)
    ]


main : Signal Html
main =
  Signal.map view indexMessage
