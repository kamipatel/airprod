@RestResource(urlMapping='/DealReferenceUpdateController/*')
global class DealReferenceUpdateRestResource {

@HttpPost
    global static string updateEntity(Contact reference) {
        update reference;
        return reference.id;
}
        

}