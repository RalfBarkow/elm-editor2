module View.Footer exposing (view)

import Element
    exposing
        ( Element
        , alignRight
        , el
        , height
        , paddingXY
        , px
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Font as Font
import Helper.Common
import Types exposing (FileLocation(..), Model, Msg)
import View.Helpers
import View.Style as Style
import View.Widget


view : Model -> Float -> Float -> Element Msg
view model width_ height_ =
    row
        [ width (View.Helpers.pxFloat (2 * Helper.Common.windowWidth width_ - 40))
        , height (View.Helpers.pxFloat height_)
        , Background.color (Element.rgb255 130 130 140)
        , Font.color (View.Helpers.gray 240)
        , Font.size 14
        , paddingXY 10 0
        , Element.moveUp 19
        , spacing 12
        ]
        [ View.Widget.openPreferencesPopupButton model
        , View.Widget.openFileListPopupButton model
        , View.Widget.openSyncPopup
        , View.Helpers.showIf (model.index /= []) (View.Widget.openIndexButton model)
        , View.Widget.toggleFileLocationButton model
        , View.Widget.saveFileToStorageButton model
        , View.Widget.openFilePopupButton model
        , View.Widget.documentTypeButton model
        , View.Widget.openNewFilePopupButton model
        , View.Widget.importFileButton
        , View.Widget.exportFileButton
        , View.Widget.exportLaTeXFileButton model
        , View.Widget.publishFileButton
        , displayFilename model
        , row [ alignRight, spacing 12 ]
            [ View.Widget.aboutButton
            ]
        ]


displayFilename : Model -> Element Msg
displayFilename model =
    let
        fileName_ =
            case model.currentDocument of
                Nothing ->
                    "No document"

                Just doc ->
                    doc.fileName

        fileName =
            case model.fileLocation of
                FilesOnDisk ->
                    fileName_

                FilesOnServer ->
                    "(" ++ fileName_ ++ ")"
    in
    el [ Element.inFront (displayMessage model) ] (text fileName)


displayMessage : Model -> Element Msg
displayMessage model =
    View.Helpers.showIf (model.messageLife > 0)
        (el
            [ width (px 250)
            , paddingXY 8 8
            , Element.moveUp 8
            , Background.color Style.paleBlueColor
            , Font.color Style.blackColor
            ]
            (text model.message)
        )
