USE [Justice]
GO

/****** Object:  View [ECR].[vwECR_CaseManager_Causes_Parties]    Script Date: 7/31/2023 5:55:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 

create view [ECR].[vwECR_CaseManager_Causes_Parties]

as

select   CauseOfActionID				=  ca.CauseOfActionID
		,CaseID							=  cch.CaseID
		,CaseConnectionCode				=  conn.code
		,CaseConnectionDescription		=  conn.Description
		,CaseNbr						=  cah.CaseNbr
		,CauseOfActionCode				=  ucc.code
		,CauseOfActionCodeDescription	=  ucc.description
		,CauseOfActionTypeDescription	=  sc.Description
		,CauseOfActionTypeID			=  ca.CauseOfActionTypeID
		,CausePartyName					=  justice.dbo.fnformatfullnamebyPartyID(xp.PartyID)
		,CausePartyNameFMLS				=  justice.dbo.fnformatfullnameFMLSbyPartyID(xp.PartyID)
		,FiledTypeDescription			=  scf.Description
		,FiledTypeKey					=  xp.FiledTypeKey
		,NodeDescription				=  (select description from justice.ECR.vwECR_NodeDescriptions crn where crn.NodeID = cah.nodeid)
		,NodeID							=  cah.NodeID

   from justice.dbo.clkcasehdr cch 
    join justice.dbo.caseassignhist cah on cah.caseassignmenthistoryid = cch.caseassignmenthistoryidcur 
    join justice.dbo.CauseOfAct ca on ca.CaseID = cch.CaseID  
    join justice.dbo.xPartyCauseOfAct  xp on xp.CauseOfActionID = ca.CauseOfActionId 

    outer apply (select top 1 ue.code, ue.description 
				    from justice.dbo.CaseParty cp 
				    join justice.dbo.CasePartyConn cpc on cpc.casePartyID = cp.casePartyID 
				    join justice.dbo.ucode ue on ue.codeid = cpc.extconnid 
				    where cp.CaseID = cch.CaseID and cp.PartyID = xp.PartyID) as Conn

/* Time Stamps */ 
  left outer join Operations.dbo.Appuser a1 on a1.userid = ca.UserIDCreate
  left outer join Operations.dbo.AppUser a2 on a2.userid = ca.UserIDChange

    /* User codes */    
    left outer join justice.dbo.ucode ucc on ucc.codeid = ca.CauseOfActionCodeID  
    left outer join Justice.dbo.ucode ufb on ufb.codeid =  ca.FiledByExtConnId   
    left outer join justice.dbo.ucode ufa on ufa.codeid  = ca.FiledAgainstExtConnId  

    /* system codes */
    join justice.dbo.sCaseCat scc on scc.casecategorykey = cch.casecategorykey 
    join justice.dbo.sCauseFiledType scf on scf.FiledTypeKey = xp.FiledTypeKey
    join justice.dbo.sCauseOfActType sc on sc.CauseOfActionTypeID = ca.CauseOfActionTypeID


    where scc.ProductIDs = 2  -- Case Manager 

     







GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The cause of action type code value' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CauseOfActionID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The unique identifier for a case. All cases have a unique identifier that never changes' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CaseID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Case Connection for cause parties' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CaseConnectionCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Case Connection code descripton for cause parties.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CaseConnectionDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The actual case number.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CaseNbr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The cause of action code value' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CauseOfActionCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The cause of action code description' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CauseOfActionCodeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The cause of action type code description' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CauseOfActionTypeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A code that tells what type this cause of action is (ex. action or counter action).' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CauseOfActionTypeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cause Party name' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CausePartyName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Caust party name in FMLS format' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'CausePartyNameFMLS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The cause party filed type code desciption' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'FiledTypeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier code for a system cause filed type entry.' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'FiledTypeKey'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The location description from the organizational chart' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'NodeDescription'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier for a location. The NodeID is the numeric value from the organizational chart' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties', @level2type=N'COLUMN',@level2name=N'NodeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The parties linked to a cause of action for a case. There can be more than one party linked to ' , @level0type=N'SCHEMA',@level0name=N'ECR', @level1type=N'VIEW',@level1name=N'vwECR_CaseManager_Causes_Parties'
GO


