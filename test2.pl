#!/usr/bin/perl

use strict;
use warnings;

use SOAP::Lite;
use Data::Dumper;

#ClientGuid	Each instance of a client application needs a unique GUID.
#ClientType	The client application type. If you are developing an application and would like adedicated client type, please send your request to:
#feedbackyarratrams.com.au.
#ClientVersion	The version of the client application. The version format has to match the following regular expression:
#"^(\d{1,3})(\.\d{1,3})?(\.\d{1,3})?(\.\d{1,5})?$".
#
#For example, 1.0, 1.0.0 or 1.0.0.0
#ClientWebServiceVersion	The current Web Service version that the client application is connecting to. The version format has to match the following expression:
#"^(\d{1,3}\.)(\d{1,3}\.)(\d{1,3}\.)(\d{1,5})$".
#
#For example: 1.0.0.0
#137fa714-39f0-44b2-aa20-e668a30f27f2

my $client_guid		= SOAP::Header->name( 'ClientGuid'		=> '137fa714-39f0-44b2-aa20-e668a30f27f2'	);
my $client_type		= SOAP::Header->name( 'ClientType'		=> 'WEBPID'					);
my $client_version	= SOAP::Header->name( 'ClientVersion'		=> '1.0.0'					);
my $client_ws_version	= SOAP::Header->name( 'ClientWebServiceVersion'	=> '6.4.0.0'					);
my $pids_header		= SOAP::Header->name( 'PidsClientHeader' )
				      ->attr( { 'xmlns' => 'http://www.yarratrams.com.au/pidsservice/' } )
				      ->value( \SOAP::Header->value( $client_guid, $client_type, $client_version, $client_ws_version ) );
my $elem		= SOAP::Data->name( 'GetMainRoutes' )->attr( { 'xmlns' => 'http://www.yarratrams.com.au/pidsservice/' } );

my $service = SOAP::Lite->endpoint('http://ws.tramtracker.com.au/pidsservice/pids.asmx' )
			->ns('http://www.yarratrams.com.au/pidsservice/')
			->proxy('http://ws.tramtracker.com.au/pidsservice/pids.asmx')
			->on_action(sub{'http://www.yarratrams.com.au/pidsservice/GetDestinationsForAllRoutes'})
			#->on_action(sub{'http://www.yarratrams.com.au/pidsservice/GetNewClientGuid'})
			#->GetMainRoutes()
			->GetDestinationsForAllRoutes( $pids_header)
			#->GetMainRoutes($elem, $pids_header)
			->result;
			#->on_action('http://www.yarratrams.com.au/pidsservice/GetMainRoutes');


print Dumper( $service) ;exit;

$service = SOAP::Lite->endpoint('http://ws.tramtracker.com.au/pidsservice/pids.asmx' )
			->ns('http://www.yarratrams.com.au/pidsservice/')
			->proxy('http://ws.tramtracker.com.au/pidsservice/pids.asmx')
			#->on_action(sub{'http://www.yarratrams.com.au/pidsservice/GetMainRoutes'})
			->on_action(sub{'http://www.yarratrams.com.au/pidsservice/GetNewClientGuid'})
			->GetNewClientGuid()
			#->GetMainRoutes()
			->result;
			#->on_action('http://www.yarratrams.com.au/pidsservice/GetMainRoutes');


print Dumper( $service) ;exit;
#$service->endpoint('http://www.yarratrams.com.au/pidsservice/');
my $r = $service->method('GetMainRoutes');

print Dumper( $r );


#POST /pidsservice/pids.asmx HTTP/1.1
#Host: ws.tramtracker.com.au
#Content-Type: text/xml; charset=utf-8
#Content-Length: length
#SOAPAction: "http://www.yarratrams.com.au/pidsservice/GetMainRoutes"
#
#<?xml version="1.0" encoding="utf-8"?>
#<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
#  <soap:Header>
#    <PidsClientHeader xmlns="http://www.yarratrams.com.au/pidsservice/">
#      <ClientGuid>guid</ClientGuid>
#      <ClientType>string</ClientType>
#      <ClientVersion>string</ClientVersion>
#      <ClientWebServiceVersion>string</ClientWebServiceVersion>
#      <OSVersion>string</OSVersion>
#    </PidsClientHeader>
#  </soap:Header>
#  <soap:Body>
#    <GetMainRoutes xmlns="http://www.yarratrams.com.au/pidsservice/" />
#  </soap:Body>
#</soap:Envelope>
