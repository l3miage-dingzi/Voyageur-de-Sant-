<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : cabinetinf.xsl
    Created on : 7 novembre 2023, 15:37
    Author     : dingzi
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
                version="1.0">
    <xsl:output method="html"/>
    <xsl:param name="destinedId" select="001"/>
    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="/">
        <html>
            <head>
                <title>cabinetinf.xsl</title>
                <link rel="stylesheet" type="text/css" href="../css/css.css"/>
                <script type="text/javascript" src="../html/js/facture.js"></script>
                <script type="text/javascript">
                    function openFacture(prenom, nom, actes) {
   var width  = 500;
   var height = 300;
   if(window.innerWidth) {
       var left = (window.innerWidth-width)/2;
       var top = (window.innerHeight-height)/2;
   }
   else {
       var left = (document.body.clientWidth-width)/2;
       var top = (document.body.clientHeight-height)/2;
   }
   var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
   var factureText = afficherFacture(prenom, nom, actes);
   factureWindow.document.write(factureText);
}
                </script>
                <link rel="stylesheet" type="text/css" href="../css/css.css"/>
            </head>
            <body>
                <b>Bonjour <xsl:value-of select="/cab:cabinet/cab:infirmiers/cab:infirmier[@id='001']/cab:prénom"/><br/></b>
                <xsl:variable name="visitesDuJour" select="/cab:cabinet/cab:patients/cab:patient/cab:visite[@intervenant=$destinedId]"/>
                <b1>Aujourd'hui, vous avez <xsl:value-of select="count($visitesDuJour)"/> patients<br/></b1>
                
                <xsl:apply-templates select="$visitesDuJour/..">
                    <xsl:sort select="cab:visite/@date"/>
                </xsl:apply-templates>
                              
            </body>
        </html>
    </xsl:template>
    <xsl:template match="cab:patient">
        <table border="1">
            <tr>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Adresse</th>
                <th>Soin(s)</th>
                <th>Facture</th>
            </tr>
            <tr>
                <td>
                    <xsl:value-of select="cab:nom"/>
                </td>
                <td>
                    <xsl:value-of select="cab:prenom"/>
                </td>
                <td>
                    <xsl:if test="cab:adresse/cab:étage">
                        Etage <xsl:value-of select="cab:adresse/cab:étage"/><br/>
                    </xsl:if>
                    <xsl:if test="cab:adresse/cab:numéro">
                        <xsl:value-of select="cab:adresse/cab:numéro"/><br/> 
                    </xsl:if>
                    <xsl:value-of select="cab:adresse/cab:rue"/><br/>
                    <xsl:value-of select="cab:adresse/cab:codePostal"/>
                </td>
                <td>
                    <xsl:apply-templates select="cab:visite[@intervenant=$destinedId]"/>
                </td>
                <td>
                    <xsl:element name="input">
            <xsl:attribute name="type">button</xsl:attribute>
            <xsl:attribute name="value">Facture</xsl:attribute>
            <xsl:attribute name="onclick">
    openFacture('<xsl:value-of select="cab:prenom"/>',
                '<xsl:value-of select="cab:nom"/>',
                '<xsl:value-of select="cab:visite/cab:acte"/>')
</xsl:attribute>
        </xsl:element>
                </td>
            </tr>
            <br/>
        </table>
       
    </xsl:template>
    <xsl:template match="cab:acte">
        <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>
        <xsl:variable name="idacte" select="@id"/>
        <li>
            <xsl:value-of select="$actes/act:actes/act:acte[@id=$idacte]/text()"/>
        </li>
    </xsl:template>
</xsl:stylesheet>
