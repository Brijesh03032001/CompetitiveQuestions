USE [Justice]
GO

/****** Object:  View [ECR].[vwECR_CaseManager_Charges]    Script Date: 5/12/2023 6:19:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 

create view [ECR].[vwECR_CaseManager_Charges]
as 

SELECT	 ChargeId					=  xc.ChargeId
		,CaseID						=  xc.CaseID
		,AMControlNumber			=  (select top 1 ca.CaseNbr 
										from justice.dbo.xCaseBaseChrg x 
										join justice.dbo.clkcasehdr c on x.CaseID = c.CaseID 
										join justice.dbo.CaseAssignHist ca on ca.caseassignmenthistoryid = c.caseassignmenthistoryidcur 
										join justice.dbo.sCaseCat scc on scc.casecategoryKey = c.casecategorykey
										where x.chargeid = xc.chargeid and scc.ProductIDs = 10 )
		,ArrestAgencyCode			=  arrest.ArrestAgencyCode
		,arrestagencyDescription	=  Arrest.arrestagencyDescription
		,ArrestAgencyID				=  Arrest.ArrestAgencyID
		,ArrestDate					=  Arrest.ArrestDate
		,ArrestID					=  arrest.ArrestID
		,ArrestOfficerBadgeNumber	=  arrest.ArrestOfficerBadgeNumber
		,ArrestOfficerID			=  Arrest.ArrestOfficerID
		,ArrestOfficerName			=  Arrest.ArrestOfficerName
		,ArrestParty				=  Arrest.ArrestParty
		,ArrestPartyID				=  Arrest.ArrestPartyID
		,ArrestTime					=  Arrest.ArrestTime
		,BondAmount					=  oh.BondAmount
		,BondState					=  sbs.Description
		,BondStateKey				=  oh.BondStateKey
		,BondTypeCode				=  ub.code
		,BondTypeDescription		=  ub.Description
		,BondTypeID					=  oh.BondTypeID
		,BookingNbr					=  Arrest.BookingNbr
		,CaseNbr					=  cah.CaseNbr
		,ChargeNumber				=  oh.ChargeNumber
		,ChargeOffenseDescription	=  oh.ChargeOffenseDescription
		,ChargeParty				=  justice.dbo.fnformatfullnamebyPartyID(chrg.PartyID)
		,ChrgComplaintCaseParty		=  justice.dbo.fnformatfullnamebyPartyID(chrg.ComplainantCasePartyID)
		,ChrgDispCode				=  ChrgDisp.ChrgDispCode
		,ChrgDispCodeDescription	=  ChrgDisp.ChrgDispCodeDescription
		,ChrgDispDate				=  ChrgDisp.ChrgDispDate
		,ChrgStatus					=  ucs.Code
		,ChrgStatusComment			=  csh.Cmmnt
		,ChrgStatusDate				=  csh.StatusDate
		,ChrgStatusDescription		=  ucs.Description
		,ChrgStatusHistoryIDCur		=  chrg.ChrgStatusHistoryIDCur
		,ComplainantCasePartyID		=  chrg.ComplainantCasePartyID
		,CriminalDispositionTypeID	=  ChrgDisp.CriminalDispositionTypeID
		,CurrentOffenseStage		=  sos.Description
		,DegreeCode					=  ud.code
		,DegreeCodeDescription		=  ud.Description
		,DegreeID					=  oh.DegreeID
		,Deleted					=  CASE chrg.deleted WHEN 0 THEN 'No' ELSE 'Yes' END
		,FineAmount					=  oh.FineAmount
		,NodeDescription			=  (select description from justice.ECR.vwECR_NodeDescriptions crn where crn.NodeID = cah.nodeid)
		,NodeID						=  cah.NodeID
		,OffenseCode				=  uoh.Code
		,OffenseCodeDescription		=  uoh.Description
		,OffenseDate				=  chrg.OffenseDate
		,OffenseDateOnAbout			=  chrg.OffenseDateOnAbout
		,OffenseDateTo				=  chrg.OffenseDateTo
		,OffenseHistoryIDCur		=  chrg.OffenseHistoryIDCur
		,OffenseID					=  oh.OffenseID
		,OffenseStageID				=  oh.OffenseStageID
		,OffenseTime				=  chrg.OffenseTime
		,OffenseTimeTo				=  chrg.OffenseTimeTo
		,PartyID					=  chrg.PartyID
		,PleaCode					=  Plea.PleaCode
		,PleaCodeDescription		=  Plea.PleaCodeDescription
		,PleaDate					=  Plea.PleaDate
		,PleaTypeID					=  plea.PleaTypeID
		,ProsecutingAgency			=  upa.code
		,ProsecutingAgencyDescr		=  upa.description
		,ProsecutingAgencyID		=  chrg.ProsecutingAgencyID
		,SONumber					=  Arrest.SONumber
		,Statute					=  oh.Statute
		,ViolationCity				=  chrg.ViolationCity
		   /* Time Stamps */
		,Chrg_TSChange				=  chrg.TimestampChange
		,Chrg_TSCreate				=  chrg.TimestampCreate
		,Chrg_UserIDCreate			=  chrg.UserIDCreate
		,Chrg_UserIDChange			=  chrg.UserIDChange
		,Chrg_UserCreate			=  a1.LoginName
		,Chrg_UserChange			=  a2.LoginName

  FROM justice.dbo.clkcasehdr cch 
  join justice.dbo.CaseAssignHist cah on cah.CaseAssignmentHistoryID = cch.caseassignmenthistoryidcur 
  join justice.dbo.xCaseBaseChrg xc on cch.CaseID = xc.CaseID 
  JOIN justice.dbo.Chrg chrg ON xc.chargeid = chrg.chargeid 
  JOIN justice.dbo.OffHist oh ON oh.offensehistoryid = chrg.offensehistoryidcur
  LEFT OUTER JOIN justice.dbo.ChrgStatusHist csh ON csh.chrgStatusHistoryID = chrg.ChrgStatusHistoryIDCur

/* Plea Event */
  outer apply (select top 1 xp.PleaTypeID,
				uc0.Code as PleaCode,
				uc0.Description as PleaCodeDescription,
				pe.EventDate as PleaDate 
						from justice.dbo.xPleaEventChrg xp 
						join justice.dbo.PleaEvent pe on xp.PleaEventID = pe.PleaEventID
						join justice.dbo.ucode uc0 on uc0.codeid = xp.PleaTypeID
						where xp.chargeid = chrg.chargeid
						order by xp.PleaEventID desc) as Plea

/* Charge Disposistion Event */
  outer apply (select tohyp 1 xcd.CriminalDispositionTypeID,
				uc0.Code as ChrgDispCode,
				uc0.Description as ChrgDispCodeDescription,
				ce.EventDate as ChrgDispDate 
						from justice.dbo.xCrimDispEventChrg xcd 
						join justice.dbo.CrimDispEvent ce on xcd.CriminalDispositionEventID = ce.CriminalDispositionEventID
						join justice.dbo.ucode uc0 on uc0.codeid = xcd.CriminalDispositionTypeID
						where xcd.chargeid = chrg.chargeid
						order by xcd.CriminalDispositionTypeID desc) as ChrgDisp

/* Arrest Information */
  outer apply (select ar.ArrestID,
					   ar.SONumber,
					   ar.PartyID as ArrestPartyID,
					   justice.dbo.fnformatfullnamebyPartyID(ar.PartyID) as ArrestParty,
					   Ar.ArrestAgencyID,
					   uar.Code as ArrestAgencyCode,
					   uar.Description as ArrestAgencyDescription,
					   ar.ArrestOfficerID, 
					   coalesce(ArrestOfficerName,justice.dbo.fnformatfullnamebyPartyID(ar.arrestofficerID)) as ArrestOfficerName,
			 
					   ArrestOfficerBadgeNumber,
					   Ar.ArrestDate,
					   Ar.ArrestTime,
					   BookingNbr
			
				from justice.dbo.OffHist oh0 
				join justice.dbo.Arrest ar on ar.arrestid = oh0.arrestid
				left outer join justice.dbo.ucode uar on uar.codeid = ar.ArrestAgencyID
				where oh0.Chargeid = chrg.chargeid and oh0.OffenseStageID = 1 ) as Arrest
  /* Time Stamps */
  LEFT OUTER JOIN operations.dbo.Appuser a1 ON a1.userid = chrg.UserIDCreate 
  LEFT OUTER JOIN operations.dbo.AppUser a2 ON a2.userid = chrg.UserIDChange 

  /* User Codes */
  LEFT OUTER JOIN justice.dbo.ucode ucs ON ucs.codeid = csh.ChrgStatusId 
  LEFT OUTER JOIN justice.dbo.ucode upa ON upa.codeid =  chrg.ProsecutingAgencyID
  JOIN justice.dbo.ucode uoh ON uoh.codeid = oh.OffenseId 
  Left outer join justice.dbo.ucode ud on ud.codeid = oh.degreeid 
  left outer join justice.dbo.ucode ub on ub.codeid = oh.BondTypeID 

  /* System Codes */
  JOIN justice.dbo.sOffStage sos ON sos.OffenseStageID = oh.OffenseStageID	 
  left outer join Justice.dbo.sBondState sbs on sbs.BondStateKey = oh.BondStateKey
  join justice.dbo.sCaseCat scc on scc.casecategorykey = cch.casecategorykey

  where scc.productIds = 2 -- Case Manager
   








GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of the charge that this detail is associated to.  If the bond setting history is by case' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChargeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The unique identifier for a case. All cases have a unique identifier that never changes' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'CaseID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Control number from Attorney manager case if the case manager case is linked to an Attorney manager case' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'AMControlNumber'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The arresting agency code value' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestAgencyCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The arresting agency code desctiption' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'arrestagencyDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier for the agency code table entry.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestAgencyID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date of arrest.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifier for an arrest.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Officer badge number.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestOfficerBadgeNumber'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier of the officer. (if arrest agency tracks officers)' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestOfficerID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of officer.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestOfficerName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The arreset party name' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestParty'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The arrest party identifier' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestPartyID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Time of arrest.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ArrestTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dollar amount of this bond.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'BondAmount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The state code for the bond' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'BondState'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique system-assigned identifier.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'BondStateKey'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The bond type code value' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'BondTypeCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The bond type description' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'BondTypeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier for a code table entry.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'BondTypeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The booking number for the jailing record' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'BookingNbr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The actual case number.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'CaseNbr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Charge number' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChargeNumber'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Charge offense description.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChargeOffenseDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The party linked to the charge. ' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChargeParty'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Complaint case party identifier' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgComplaintCaseParty'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'charge disposition code value' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgDispCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'charge disposition code description' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgDispCodeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'charge disposition date' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgDispDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'charge disposition status code value' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'charge disposition status comment' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgStatusComment'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'charge disposition status date' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgStatusDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'charge disposition status code description' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgStatusDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifying for the charge history status' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ChrgStatusHistoryIDCur'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The complainant Case Party Indentifier' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ComplainantCasePartyID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID for the disposition type code that will be added to each charge on the cases processed by the job.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'CriminalDispositionTypeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The current offense stage for the charge' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'CurrentOffenseStage'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The degree code value' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'DegreeCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description for the degree code' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'DegreeCodeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier for a code table entry.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'DegreeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the record has been soft deleted.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'Deleted'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Recommended fine amount.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'FineAmount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The location description from the organizational chart' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'NodeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier for a location. The NodeID is the numeric value from the organizational chart' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'NodeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code value for the Offense Code' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description for the Offense Code' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseCodeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date of the offense.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Offense date on or about flag.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseDateOnAbout'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Offense to date.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseDateTo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier for offense history.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseHistoryIDCur'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifier for an offense.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifier for an offense stage.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseStageID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Time of offense.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Offense to time.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'OffenseTimeTo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifier for a party.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'PartyID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Plea Code selected in Public Access for this EntityID.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'PleaCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Plea Code description from the Code Table' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'PleaCodeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date that the plea was made for the offense.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'PleaDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID for the plea type code that will be added to each charge on the cases processed by the job.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'PleaTypeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code value for the Prosecuting agency from the code table' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ProsecutingAgency'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code description for the Prosecuting agency from the code table' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ProsecutingAgencyDescr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The unique ID for the prosecutor agency' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ProsecutingAgencyID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SO Number for the defendant' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'SONumber'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The regulation and rules.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'Statute'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The violation city from the arrest record or the citation' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'ViolationCity'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Last Time the record was modified' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'Chrg_TSChange'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The time stamp when the record was created' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'Chrg_TSCreate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The user ID who created the record' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'Chrg_UserIDCreate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Last user ID who modified the record' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'Chrg_UserIDChange'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The  user login name who created the record' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'Chrg_UserCreate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Last user login name who modified the record' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges', @level2type=N'COLUMN',@level2name=N'Chrg_UserChange'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detail view for the criminal charges linked to a case.  This view shows the current stage which is identified by a star in the UI' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Charges'
GO


