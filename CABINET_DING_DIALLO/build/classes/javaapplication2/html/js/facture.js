var AMIVAL = 3.15;
var AISVAL = 2.65;
var DIVAL = 10.0;

var totalFacture = 0.0;

function afficherFacture(prenom, nom, actes)
{
    totalFacture = 0.0;
    var text = "<html>\n";
    text +=
            "    <head>\n\
            <title>Facture</title>\n\
            <link rel='stylesheet' type='text/css' href='../css/css.css'/>\n\
         </head>\n\
         <body>\n";


    text += "Facture pour " + prenom + " " + nom + "<br/>";


    // Trouver l'adresse du patient
    try{
        var xmlDoc = loadXMLDoc("../xml/cabinetInfirmier (2).xml");
        var patients = xmlDoc.getElementsByTagName("cab:patient");
        var i = 0;
        var found = false;    
        while ((i < patients.length) && (!found)) {
            var patient = patients[i];
            var localNom = patient.getElementsByTagName("cab:nom")[0].childNodes[0].nodeValue;
            var localPrenom = patient.getElementsByTagName("cab:prenom")[0].childNodes[0].nodeValue;
            if ((nom === localNom) && (prenom === localPrenom)) {
                found = true;  
            }
            else {
                i++;
            }
        }


        if (found) {
            text += "Adresse: <br/>";
            // On rÃ©cupÃ¨re l'adresse du patient
            var adresse;
            adresse = patient.getElementsByTagName("cab:adresse")[0];
            text += adresseToText(adresse);
            //text += adresse.getElementsByTagName("cab:étage")[0].childNodes[0].nodeValue;
            text += "<br/>";

            var nSS = "0";
            nSS = patient.getElementsByTagName("cab:numéro")[0].childNodes[0].nodeValue;

            text += "Numéro de sécurité sociale: " + nSS + "\n";
        }
        text += "<br/>";
        text += "<table border='1'  bgcolor='#CCCCCC'>";
        text += "<tr>";
        text += "<td> Type </td> <td> Clé </td> <td> Intitulé </td> <td> Coef </td> <td> Tarif </td>";
        text += "</tr>";

        //var acteIds = actes.split(" ");
        var visites=xmlDoc.getElementsByTagName("cab:visite");
        var visit=visites[i];
        var acte=visit.getElementsByTagName("cab:acte");
        for (var j = 0; j < acte.length; j++) {
            text += "<tr>";
            var acteId = acte[j].getAttribute("id");
            text += acteTable(acteId);
            text += "</tr>";
        }
        
        text += "<tr><td colspan='4'>Total</td><td>" + totalFacture + "</td></tr>\n";
        
        text +="</table>";
    }catch(error){
        text+=error;
    }
    
    




/*
    // Tableau rÃ©capitulatif des Actes et de leur tarif
    */
     
     
    text +=
            "    </body>\n\
    </html>\n";

    return text;
}

// Mise en forme d'un noeud adresse pour affichage en html
function adresseToText(adresse)
{
    var str = "";
    // Mise en forme de l'adresse du patient
    // A complÃ©ter
    try{
        var etage="étage :"+adresse.getElementsByTagName("cab:étage")[0].childNodes[0].nodeValue+ "<br/>";
    }catch(error){

    }
    var numéro="numéro :"+adresse.getElementsByTagName("cab:numéro")[0].childNodes[0].nodeValue+ "<br/>";
    var rue="rue :"+adresse.getElementsByTagName("cab:rue")[0].childNodes[0].nodeValue+ "<br/>";
    var ville="ville :"+adresse.getElementsByTagName("cab:ville")[0].childNodes[0].nodeValue+ "<br/>";
    var codePostal="codePostal :"+adresse.getElementsByTagName("cab:codePostal")[0].childNodes[0].nodeValue+ "<br/>";
    str=str+etage+numéro+rue+ville+codePostal;
    return str;
}


function acteTable(acteId)
{
    var str = "";

    var xmlDoc = loadXMLDoc("../xml/actes.xml");
    var actes=xmlDoc.getElementsByTagName("acte");
    // actes = rÃ©cupÃ©rer les actes de xmlDoc

    // ClÃ© de l'acte (3 lettres)
    var cle;
    // Coef de l'acte (nombre)
    var coef;
    // Type id pour pouvoir rÃ©cupÃ©rer la chaÃ®ne de caractÃ¨res du type 
    //  dans les sous-Ã©lÃ©ments de types
    var typeId;
    // ChaÃ®ne de caractÃ¨re du type
    var type = "";
    // ...
    // IntitulÃ© de l'acte
    var intitule;

    // Tarif = (lettre-clÃ©)xcoefficient (utiliser les constantes 
    // var AMIVAL = 3.15; var AISVAL = 2.65; et var DIVAL = 10.0;)
    // (cf  http://www.infirmiers.com/votre-carriere/ide-liberale/la-cotation-des-actes-ou-comment-utiliser-la-nomenclature.html)      
    var tarif = 0.0;

    // Trouver l'acte qui correspond
    var i = 0;
    var found = false;
    
// A dÃ©-commenter dÃ¨s que actes aura le bon type...
    while ((i < actes.length) && (!found)) {
        // A complÃ©ter (cf mÃ©thode plus haut)
        var acte = actes[i];
        var locleacteId = acte.getAttribute("id");
        if(locleacteId == acteId){
            found = true;
        }else{
            i++;
        }
    }

    if (found) {
        // A complÃ©ter
        cle = acte.getAttribute("clé");
        coef = acte.getAttribute("coef");
        typeId = acte.getAttribute("id");
        type = acte.getAttribute("type");
        intitule = acte.childNodes[0].nodeValue;
        if(cle=="AMI"){
            tarif=AMIVAL*parseFloat(coef);
        }else if(cle=="AIS"){
            tarif=AISVAL*parseFloat(coef);
        }
        //tarif = ;
    }

    // A modifier
    str += "<td>" + type + "</td>";
    str += "<td>" + cle + "</td>";
    str += "<td>" + intitule + "</td>";
    str += "<td>" + coef+ "</td>";
    str += "<td>" + tarif + "</td>";
    totalFacture += tarif;

    return str;
}



// Fonction qui charge un document XML
function loadXMLDoc(docName)
{
    var xmlhttp;
    if (window.XMLHttpRequest)
    {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    }
    else
    {// code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    xmlhttp.open("GET", docName, false);
    xmlhttp.send();
    xmlDoc = xmlhttp.responseXML;

    return xmlDoc;
}