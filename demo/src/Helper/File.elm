module Helper.File exposing
    ( docType
    , exportFile
    , fileExtension
    , getDocument
    , getListOfFilesInLocalStorage
    , read
    , requestFile
    , saveFile
    , saveFileToLocalStorage
    , saveFileToLocalStorage_
    , titleFromFileName
    , updateDocType
    )

import Document exposing (Document)
import Editor
import File exposing (File)
import File.Download as Download
import File.Select as Select
import Http
import MiniLatex.Export
import Outside
import Task exposing (Task)
import Types exposing (DocType(..), Model, Msg(..))


getDocument : String -> Cmd Msg
getDocument fileName =
    Http.get
        { url = Debug.log "URL" <| "http://localhost:4000/document/" ++ fileName
        , expect = Http.expectJson GotDocument Outside.documentDecoder
        }



-- FILE I/O


updateDocType : DocType -> String -> String
updateDocType docType_ fileName =
    case docType_ of
        MiniLaTeXDoc ->
            titleFromFileName fileName ++ ".tex"

        MarkdownDoc ->
            titleFromFileName fileName ++ ".md"


titleFromFileName : String -> String
titleFromFileName fileName =
    fileName
        |> String.split "."
        |> List.reverse
        |> List.drop 1
        |> List.reverse
        |> String.join "."


fileExtension : String -> String
fileExtension str =
    str |> String.split "." |> List.reverse |> List.head |> Maybe.withDefault "txt"


read : File -> Cmd Msg
read file =
    Task.perform DocumentLoaded (File.toString file)


requestFile : Cmd Msg
requestFile =
    Select.file [ "text/markdown", "text/x-tex" ] RequestedFile


saveFile : Model -> Cmd msg
saveFile model =
    let
        content =
            "uuid: " ++ model.document.id ++ "\n\n" ++ model.document.content

        fileName =
            model.document.fileName
    in
    case model.docType of
        MarkdownDoc ->
            Download.string fileName "text/markdown" content

        MiniLaTeXDoc ->
            Download.string fileName "text/x-tex" content


saveFileToLocalStorage : Model -> Cmd msg
saveFileToLocalStorage model =
    saveFileToLocalStorage_ model.document


saveFileToLocalStorage_ : Document -> Cmd msg
saveFileToLocalStorage_ document =
    Outside.sendInfo (Outside.WriteFile document)


getListOfFilesInLocalStorage : Cmd msg
getListOfFilesInLocalStorage =
    Outside.sendInfo Outside.AskForFileList


exportFile : Model -> Cmd msg
exportFile model =
    case ( model.docType, model.fileName ) of
        ( MarkdownDoc, Just fileName ) ->
            Cmd.none

        ( MiniLaTeXDoc, Just fileName ) ->
            let
                contentForExport =
                    Editor.getContent model.editor |> MiniLatex.Export.toLaTeX
            in
            Download.string fileName "text/x-tex" contentForExport

        ( _, _ ) ->
            Cmd.none


docType : String -> DocType
docType fileName =
    case fileExtension fileName of
        "md" ->
            MarkdownDoc

        "tex" ->
            MiniLaTeXDoc

        "latex" ->
            MiniLaTeXDoc

        _ ->
            MarkdownDoc
