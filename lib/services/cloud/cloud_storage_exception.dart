class CloudStorageException implements Exception{
  const CloudStorageException();
}


//C in crud
class CouldNoteCreateNoteException extends CloudStorageException {}

//R in crud
class CouldNoteGetAllNoteException extends CloudStorageException {}

//U in crud
class CouldNoteUpdateNoteException extends CloudStorageException {}

//D in crud
class CouldNoteDeleteNoteException extends CloudStorageException {}
