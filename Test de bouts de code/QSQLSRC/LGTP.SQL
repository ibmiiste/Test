BEGIN
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
      BEGIN END;
   DROP PROCEDURE LGTP;
END;

CREATE PROCEDURE  btodr.LGTP(P_CODUEX DEC(8, 0))    
  SPECIFIC btodr.LGTP
  LANGUAGE SQL 
  RESULT SET 1
  SET OPTION DBGVIEW = *SOURCE 

BEGIN  
DECLARE BFX char(5);
DECLARE STMT char(2048); 
DECLARE LGT_CURSOR CURSOR FOR LGT_STMT; 

Set schema Bfbase;
  
SELECT 'BFX' Concat CAGEXP INTO BFX
  FROM Bfbase.BNUEXP WHERE CODUEX=P_CODUEX; 
  

SET STMT =
    'with r  as (select * from bnxlgp where cbasel=''R''),
         t  as (select * from bnxlgp where cbasel=''T''),
         lr as (select * from bnlgtp),
         lt as (select DEC('||P_CODUEX ||'/ 1000000, 2, 0) * 1000000 +
                nuexpl as coduex, l.*, oprlgt
                from '||BFX||'.blgtl00 l left join '||BFX||'.tlgtl01
                     using(nidlgt))
    select ifnull(r.cidmcl, t.cidmcl), r.coduex coduexr, r.nbatim nbatimr,
           r.nescal nescalr, r.netage netager, r.nposit npositr,
           t.coduex coduext, t.nbatim nbatimt, t.nescal nescalt,
           t.netage netaget, t.nposit npositt,
           case when fill3a=''THE'' then ifnull(lt.trefcl, lr.trefcl)
                else ifnull(lr.trefcl, lt.trefcl) end AS customerReference,
           case when fill3a=''THE'' then ifnull(lt.templg, lr.templg)
                else ifnull(lr.templg, lt.templg) end AS location,
           case when fill3a=''THE'' then ifnull(lt.oprlgt, lr.oprlog)
                else ifnull(lr.oprlog, lt.oprlgt) end AS owner,
           case when fill3a=''THE'' then ifnull(lt.ctitre, lr.ctitre)
                else ifnull(lr.ctitre, lt.ctitre) end AS tenantTitle,
           case when fill3a=''THE'' then ifnull(lt.ooccup, lr.ooccup)
                else ifnull(lr.ooccup, lt.ooccup) end AS tenantName
      from r full join t on r.cidmcl=t.cidmcl left join lr on
           (lr.coduex, lr.nbatim, lr.nescal, lr.netage, lr.nposit) =
           (r.coduex, r.nbatim, r.nescal, r.netage, r.nposit) left join lt on
           (lt.coduex, lt.nbatim, lt.nescal, lt.netage, lt.nposit) =
           (t.coduex, t.nbatim, t.nescal, t.netage, t.nposit) left join
           bnucop c on c.coduex=ifnull(r.coduex, t.coduex)
      where r.coduex='||P_CODUEX||' or t.coduex='||P_CODUEX;       
      
      PREPARE LGT_STMT FROM STMT; 
      
      
    
    OPEN LGT_CURSOR;
    
    SET RESULT SETS CURSOR LGT_CURSOR;
    

  END