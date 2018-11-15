﻿CREATE TABLE [dbo].[t_svc_TravelCB2] (
    [id_source_sess]                 BINARY (16)    NOT NULL,
    [id_parent_source_sess]          BINARY (16)    NULL,
    [id_external]                    BINARY (16)    NULL,
    [c_RawExtractJobRunID]           NVARCHAR (255) NOT NULL,
    [c_RawExtractRunDate]            NVARCHAR (255) NULL,
    [c_RawTransactionType]           NVARCHAR (255) NULL,
    [c_RawBillingPeriodStartDate]    NVARCHAR (255) NULL,
    [c_RawBillingPeriodEndDate]      NVARCHAR (255) NULL,
    [c_RawClientGUID]                NVARCHAR (255) NULL,
    [c_RawExternalReferenceID]       NVARCHAR (255) NULL,
    [c_RawClientLegalName]           NVARCHAR (255) NULL,
    [c_RawCompanyName]               NVARCHAR (255) NULL,
    [c_RawBillGroupID]               NVARCHAR (255) NULL,
    [c_RawCognosTier]                NVARCHAR (255) NULL,
    [c_RawEmployeeFirstName]         NVARCHAR (255) NULL,
    [c_RawEmployeeLastName]          NVARCHAR (255) NULL,
    [c_RawEmployeeMI]                NVARCHAR (255) NULL,
    [c_RawEmployeeLoginID]           NVARCHAR (255) NULL,
    [c_RawEmployeeCountry]           NVARCHAR (255) NULL,
    [c_RawEmployeeCountryISO]        NVARCHAR (255) NULL,
    [c_RawEmployeeCostCenter]        NVARCHAR (255) NULL,
    [c_RawOrgUnitName]               NVARCHAR (255) NULL,
    [c_RawEmployeeEmail]             NVARCHAR (255) NULL,
    [c_RawProductName]               NVARCHAR (255) NULL,
    [c_RawEventCode]                 NVARCHAR (255) NULL,
    [c_RawEventAbbr]                 NVARCHAR (255) NULL,
    [c_RawEventName]                 NVARCHAR (255) NULL,
    [c_RawCLIQBOOKEventID]           NVARCHAR (255) NULL,
    [c_RawEventDate]                 NVARCHAR (255) NULL,
    [c_RawTripID]                    NVARCHAR (255) NULL,
    [c_RawAlternateTripID]           NVARCHAR (255) NULL,
    [c_RawAttendeeID]                NVARCHAR (255) NULL,
    [c_RawRecordLocator]             NVARCHAR (255) NULL,
    [c_RawGDSRecordLocator]          NVARCHAR (255) NULL,
    [c_RawTripRecordLocator]         NVARCHAR (255) NULL,
    [c_RawBookingSource]             NVARCHAR (255) NULL,
    [c_RawTicketChangeID]            NVARCHAR (255) NULL,
    [c_RawAir]                       NVARCHAR (255) NULL,
    [c_RawCar]                       NVARCHAR (255) NULL,
    [c_RawHotel]                     NVARCHAR (255) NULL,
    [c_RawLimo]                      NVARCHAR (255) NULL,
    [c_RawTicketExchanged]           NVARCHAR (255) NULL,
    [c_RawSabreConvienceFee]         NVARCHAR (255) NULL,
    [c_RawTravelCliqbookCompanyID]   NVARCHAR (255) NULL,
    [c_RawBookingAgencyCompanyID]    NVARCHAR (255) NULL,
    [c_RawBookingAgencyCustomerName] NVARCHAR (255) NULL,
    [c_RawNumberPassengers]          NVARCHAR (255) NULL,
    [c_RawTravelConfigID]            NVARCHAR (255) NULL,
    [c_RawTravelConfigName]          NVARCHAR (255) NULL,
    [c_RawDemoStatus]                NVARCHAR (255) NULL,
    [c_RawMeetingID]                 NVARCHAR (255) NULL,
    [c_RawMeetingRegDateUTC]         NVARCHAR (255) NULL,
    [c_RawMeetingRegistrationDate]   NVARCHAR (255) NULL,
    [c_RawMeetingAttendeeID]         NVARCHAR (255) NULL,
    [c_RawMeetingName]               NVARCHAR (255) NULL,
    [c_RawFullfillmentAgency]        NVARCHAR (255) NULL,
    [c_RawFullfillmentAgencyID]      NVARCHAR (255) NULL,
    [c_RawIsBillable]                NVARCHAR (255) NULL,
    [c_RawPreRatedAmount]            NVARCHAR (255) NULL,
    [c_RawIntlBillingFlag]           NVARCHAR (255) NULL,
    [c_RawCustomField1]              NVARCHAR (255) NULL,
    [c_RawCustomField2]              NVARCHAR (255) NULL,
    [c_RawCustomField3]              NVARCHAR (255) NULL,
    [c_RawCustomField4]              NVARCHAR (255) NULL,
    [c_RawCustomField5]              NVARCHAR (255) NULL,
    [c_RawCustomField6]              NVARCHAR (255) NULL,
    [c_RawCustomField7]              NVARCHAR (255) NULL,
    [c_RawCustomField8]              NVARCHAR (255) NULL,
    [c_RawCustomField9]              NVARCHAR (255) NULL,
    [c_RawCustomField10]             NVARCHAR (255) NULL,
    [c_RawCustomField11]             NVARCHAR (255) NULL,
    [c_RawCustomField12]             NVARCHAR (255) NULL,
    [c_RawCustomField13]             NVARCHAR (255) NULL,
    [c_RawCustomField14]             NVARCHAR (255) NULL,
    [c_RawCustomField15]             NVARCHAR (255) NULL,
    [c_RawCustomField16]             NVARCHAR (255) NULL,
    [c_RawCustomField17]             NVARCHAR (255) NULL,
    [c_RawCustomField18]             NVARCHAR (255) NULL,
    [c_RawCustomField19]             NVARCHAR (255) NULL,
    [c_RawCustomField20]             NVARCHAR (255) NULL,
    [c_RawExpenseID]                 NVARCHAR (255) NULL,
    [c_RawRateDate]                  NVARCHAR (255) NULL,
    [c_RawUniquenessCode]            NVARCHAR (255) NULL,
    [c_RawUniquenessID]              NVARCHAR (255) NULL,
    [c_RawUniquenessViolation]       NVARCHAR (255) NULL,
    [c__IntervalID]                  INT            NULL,
    [c__TransactionCookie]           NVARCHAR (256) NULL,
    [c__Resubmit]                    CHAR (1)       NULL,
    [c__CollectionID]                BINARY (16)    NULL,
    PRIMARY KEY CLUSTERED ([id_source_sess] ASC)
);
