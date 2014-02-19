<?xml version="1.0" encoding="utf-8"?>
<!-- Data Dictionary Version v3.3.3.130926 -->
<iso:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:nem="http://www.nemsis.org" xmlns:fct="localFunctions" queryBinding="xslt2">
    <iso:ns prefix="nem" uri="http://www.nemsis.org"/>
    <iso:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
    <iso:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
    <iso:ns prefix="fct" uri="localFunctions"/>
    <iso:title>NEMSIS Compliance Test ISO Schematron File</iso:title>


  <!-- This is the a pattern for a state required/recommended elements when ePatient.13 is 9906001 (Female), the eHistory.18 - Pregnancy must be 3118003 (Possible, Uncomfirmed). -->
  <iso:pattern abstract="false" id="complianceTestStructureRule1" name ="Verify ePatient.13 and eHistory for female">
    <iso:title>When ePatient.13 is 9906001, eHistory.18 must be 3118003.</iso:title>
    <iso:rule context="nem:Header/nem:PatientCareReport" role="[FATAL]" >
      <iso:let name="patientCare" value="normalize-space(.)" />
      <iso:let name="ePatient13" value="normalize-space(./nem:ePatient/nem:ePatient.13/.)" />
      <iso:let name="eHistory18" value="normalize-space(./nem:eHistory/nem:eHistory.18/.)" />
      <iso:assert role="[FATAL]" test="if (number($ePatient13) = 9906001) then (if (number($eHistory18) = 3118003) then true() else false()) else true()" >
        ePatient.13 - Gender is 9906001 (Female), but eHistory.18 - Pregnancy is <iso:value-of select="$eHistory18" /> while it must be 3118003 (Possible, Uncomfirmed).
      </iso:assert>
    </iso:rule>
  </iso:pattern>


  <!-- This is the a pattern for a state required/recommended elements eTimes.03 - Unit Notified by Dispatch Date/Time before eTimes.13 - Unit Back in Service Date/Time. -->
  <iso:pattern abstract="false" id="complianceTestStructureRule2" name ="Verify eTimes.03 is before eTimes.13">
    <iso:title>eTimes.03 - Unit Notied by Dispatch Date/Time is before eTimes.13 - Unit Back in Service Date/Time</iso:title>
    <iso:rule context="nem:Header/nem:PatientCareReport/nem:eTimes" role="[FATAL]" >
      <iso:let name="eTimes" value="normalize-space(.)" />
      <iso:let name="eTimes03" value="normalize-space(./nem:eTimes.03/.)" />
      <iso:let name="eTimes13" value="normalize-space(./nem:eTimes.13/.)" />
      <iso:let name="eTimes03All" value="normalize-space(concat(substring($eTimes03,1,4), substring($eTimes03,6,2), substring($eTimes03,9,2), substring($eTimes03,12,2), substring($eTimes03,15,2), substring($eTimes03,18,2)))" />
      <iso:let name="eTimes13All" value="normalize-space(concat(substring($eTimes13,1,4), substring($eTimes13,6,2), substring($eTimes13,9,2), substring($eTimes13,12,2), substring($eTimes13,15,2), substring($eTimes13,18,2)))" />
      <iso:assert role="[FATAL]" test=" if (number($eTimes03All) &lt; number($eTimes13All)) then true() else false() " >
        eTimes.03 - Unit Notified by Dispatch Date/Time <iso:value-of select="$eTimes03" /> should be before eTimes.13 - Unit Back in Service Date/Time <iso:value-of select="$eTimes13" />.
      </iso:assert>
    </iso:rule>
  </iso:pattern>


  <!-- This is the a pattern for a state required/recommended elements eDispatch.01 - Complaint Reported by Dispatch must not be 2301069. -->
  <iso:pattern abstract="false" id="complianceTestStructureRule3" name ="Verify ">
    <iso:title>eDispatch.01 - Complaint Reported by Dispatch must not be 2301069</iso:title>
    <iso:rule context="nem:Header/nem:PatientCareReport/nem:eDispatch" role="[FATAL]" >
      <iso:let name="eDispatch" value="normalize-space(.)" />
      <iso:let name="eDispatch01" value="normalize-space(./nem:eDispatch.01/.)" />
      <iso:assert role="[FATAL]" test="if (number($eDispatch01) = 2301007) then false() else true()" >
        eDispatch.01 - Complaint Reported by Dispatch must NOT be 2301007.
      </iso:assert>
    </iso:rule>
  </iso:pattern>
</iso:schema>