CREATE XML SCHEMA COLLECTION [dbo].[ProductAttributeSchema]
    AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsd:element name="Product" type="ProductType" />
  <xsd:complexType name="ProductType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="Weight" type="xsd:decimal" />
          <xsd:element name="Manufacturer" type="xsd:string" />
          <xsd:element name="Material" type="xsd:string" />
          <xsd:element name="Warranty" type="xsd:int" />
          <xsd:element name="Color" type="xsd:string" />
        </xsd:sequence>
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
</xsd:schema>';

