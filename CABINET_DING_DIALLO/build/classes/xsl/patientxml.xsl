<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patientxml.xsl
    Created on : 2023年11月12日, 03:56
    Author     : ding
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
                version="1.0">
    <xsl:output method="xml"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:param name="destinedName" select="'Alécole'"/>
    <xsl:template match="/">
        <patient>
            <xsl:variable name="lePatient" select="/cab:cabinet/cab:patients/cab:patient[cab:nom/text() = $destinedName]" />
            <nom><xsl:value-of select="$lePatient/cab:nom" /></nom>
            <prenom><xsl:value-of select="$lePatient/cab:prenom" /></prenom>
            <sexe><xsl:value-of select="$lePatient/cab:sexe" /></sexe>
            <naissance><xsl:value-of select="$lePatient/cab:naissance" /></naissance>
            <numéro><xsl:value-of select="$lePatient/cab:numéro" /></numéro>
            <adresse>
                <xsl:if test="$lePatient/cab:adresse/cab:étage">
                    <xsl:value-of select="$lePatient/cab:adresse/cab:étage/text()"/>
                </xsl:if>
                <xsl:if test="$lePatient/cab:adresse/cab:numéro">
                    <xsl:value-of select="$lePatient/cab:adresse/cab:numéro/text()"/>
                </xsl:if>
                <rue><xsl:value-of select="$lePatient/cab:adresse/cab:rue" /></rue>
                <ville><xsl:value-of select="$lePatient/cab:adresse/cab:ville" /></ville>
                <codePostal><xsl:value-of select="$lePatient/cab:adresse/cab:codePostal" /></codePostal>
            </adresse>
            <xsl:apply-templates select="$lePatient/cab:visite" >
                <xsl:sort select="@date" order="ascending"/>
            </xsl:apply-templates>
        </patient>
    </xsl:template>
    
    <xsl:template match="cab:visite">
        <xsl:variable name="inter" select="@intervenant" />
        <xsl:element name="visite">
            <xsl:attribute name="date">
                <xsl:value-of select="@date" />
            </xsl:attribute>
            <xsl:apply-templates select="/cab:cabinet/cab:infirmiers/cab:infirmier[@id = $inter]" />
            <xsl:apply-templates select="cab:acte" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="cab:infirmier">
        <xsl:element name="intervenant">
            <nom><xsl:value-of select="cab:nom" /></nom>
            <prénom><xsl:value-of select="cab:prénom" /></prénom>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="cab:acte">
        <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>
        <xsl:variable name="idacte" select="@id" />
        <acte>
            <xsl:value-of select="$actes/act:actes/act:acte[@id=$idacte]/text()" />
        </acte>
    </xsl:template>
</xsl:stylesheet>
