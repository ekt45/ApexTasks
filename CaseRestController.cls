@RestResource(urlMapping='/cases/*')
global with sharing class CaseRestController {
    
    @HttpGet
    global static Case getCase() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            Id caseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1); //Interesante también coger el valor por el id (ej: "/services/cases?id=*")
            Case c = CaseService.getCase(caseId);
            res.statusCode = 200; //Ok

            return c;
        }catch (QueryException e) {
            res.statusCode = 404; //Not found -> Ej: No existe el id o el recurso al que se intenta acceder
            res.responseBody = Blob.valueOf(JSON.serialize('No existe el caso: ' + e.getMessage())); //Devolvemos el error en formato JSON
            return null;
        }
        
        catch (NoAccessException e) {
            res.statusCode = 403; //Forbidden -> Ej: No tienes permisos para acceder a este recurso)
            res.responseBody = Blob.valueOf(JSON.serialize('No tienes permisos para acceder a este recurso: ' + e.getMessage()));
            return null;
        }
        
        catch (Exception e) {
            res.statusCode = 400; //Bad Request -> Mala solicitud o error desconocido
            res.responseBody = Blob.valueOf(JSON.serialize('Error al obtener el caso: ' + e.getMessage())); //Devolvemos el error en formato JSON
            return null;
        }
    }

    @HttpPost
    global static Id createCase() {
        RestResponse res = RestContext.response;

        try {
            String jsonString = RestContext.request.requestBody.toString(); //Convierte el body en un string 
            Id newCaseId = CaseService.createCase(jsonString);
            res.statusCode = 201; // Creado

            return newCaseId;
        } catch (DmlException e) {
            res.statusCode = 400; //Bad request -> ej: Faltan campos requeridos
            res.responseBody = Blob.valueOf(JSON.serialize('Error al introducir: ' + e.getMessage())); //Devolvemos el error en formato JSON
            return null;
        }
        
        catch (NoAccessException e) {
            res.statusCode = 403; //Forbidden -> Ej: No tienes permisos para acceder a este recurso)
            res.responseBody = Blob.valueOf(JSON.serialize('No tienes permisos para acceder a este recurso: ' + e.getMessage()));
            return null;
        }
        
        catch (Exception e) {
            res.statusCode = 500; //Bad Request -> Mala solicitud o error desconocido
            res.responseBody = Blob.valueOf(JSON.serialize('Error interno: ' + e.getMessage())); //Devolvemos el error en formato JSON
            return null;
        }
    }

    @HttpPatch
    global static Id updateCustomCase() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            Id caseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            String jsonString = RestContext.request.requestBody.toString();
            Id updatedId = CaseService.updateCase(caseId, jsonString);
            res.statusCode = 200; //Ok

            return updatedId;
        } catch (QueryException e) {
            res.statusCode = 404; //Not found -> Ej: No existe el id o el recurso al que se intenta acceder
            res.responseBody = Blob.valueOf(JSON.serialize('No existe el caso: ' + e.getMessage())); //Devolvemos el error en formato JSON
            return null;
        }
        
        catch (NoAccessException e) {
            res.statusCode = 403; //Forbidden -> Ej: No tienes permisos para acceder a este recurso)
            res.responseBody = Blob.valueOf(JSON.serialize('No tienes permisos para acceder a este recurso: ' + e.getMessage()));
            return null;
        }

        catch(DmlException e) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize('Error al actualizar: ' + e.getMessage())); //Devolvemos el error en formato JSON
            return null;
        }
        catch (Exception e) {
            res.statusCode = 500; //Bad Request -> Mala solicitud o error desconocido
            res.responseBody = Blob.valueOf(JSON.serialize('Error interno: ' + e.getMessage())); //Devolvemos el error en formato JSON
            return null;
        }
    }

    @HttpDelete
    global static void deleteCase() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            Id caseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            CaseService.deleteCase(caseId);
            res.statusCode = 204; //Eliminado correctamente

        } catch (QueryException e) {
            res.statusCode = 404; //Not found -> Ej: No existe el id o el recurso al que se intenta acceder
            res.responseBody = Blob.valueOf(JSON.serialize('No existe el caso: ' + e.getMessage())); //Devolvemos el error en formato JSON
        }
        
        catch (NoAccessException e) {
            res.statusCode = 403; //Forbidden -> Ej: No tienes permisos para acceder a este recurso)
            res.responseBody = Blob.valueOf(JSON.serialize('No tienes permisos para acceder a este recurso: ' + e.getMessage()));
        }
        
        catch (Exception e) {
            res.statusCode = 400; //Bad Request -> Mala solicitud o error desconocido
            res.responseBody = Blob.valueOf(JSON.serialize('Error al borrar el caso: ' + e.getMessage())); //Devolvemos el error en formato JSON
        }
    }   
}
