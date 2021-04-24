import {Document} from "../document.ts";
import {documents } from "../documents.ts";
import {persistData} from  "../db.ts"

const hasSameId = (a: Document, b: Document) => a.id == b.id;

const isNotPresent = (d: Document, docs: Array<Document>) =>
  docs.filter((doc) => hasSameId(doc, d)).length == 0;


export const updateDoc = (sourceDoc: Document, targetDoc: Document) =>
  {
   if (sourceDoc.id == targetDoc.id)  {
        sourceDoc
     } else {
        targetDoc
     }
   }

// Add a new document
export const updateDocument = async ({
  request,
  response,
}: {
  request: any;
  response: any;
}) => {
  const {
    value : {token, fileName, id, content},
  } = await request.body();
  response.headers.set("Access-Control-Allow-Origin", "*");
  response.headers.append("Access-Control-Allow-Methods", "PUT, OPTIONS");
  response.headers.append(
    "Access-Control-Allow-Headers",
    "X-Requested-With, Content-Type, Accept, Origin",
  );

  if (token == "abracadabra") {
    const sourceDoc: Document = { id: id, fileName: fileName, content: content };
    if (isNotPresent(sourceDoc, documents)) {
      documents.push(sourceDoc);
      persistData(documents)
      console.log("added: " + sourceDoc.fileName);
      response.body = { msg: "Added: " + sourceDoc.fileName};
      response.status = 200;
    } else {
      documents.forEach((d:Document) => updateDoc(sourceDoc, d))
      persistData(documents)
      console.log("updated: " + sourceDoc.fileName);
      response.body = { msg: "Updated: " + sourceDoc.fileName };
      response.status = 200;
    }
  } else {
    response.body = { msg: "Token does not match" };
    response.status = 400;
  }
};
