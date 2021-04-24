

// DATA STRUCTURES

export interface Document {
  id: string;
  fileName: string;
  author: string;
  timeCreated: number;
  timeUpdated: number;
  timeSynced: number | null;
  tags: string[];
  categories:string[];
  title: string;
  subtitle: string;
  abstract: string;
  belongsTo: string;
  docType: string;
  content: string;
}


export interface Metadata {
  id: string;
  fileName: string;
  author: string;
  timeCreated: number;
  timeUpdated: number;
  timeSynced: number | null;
  tags: string[];
  categories:string[];
  title: string;
  subtitle: string;
  abstract: string;
  belongsTo: string;
  docType: string;


}
// 11 fields
