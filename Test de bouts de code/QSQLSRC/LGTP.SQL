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
DECLARE STMT char(4096); 
DECLARE LGT_CURSOR CURSOR FOR LGT_STMT; 

SET CURRENT PATH QTEMP, BTODR, BFBASE;

SELECT 'BFX' CONCAT cagexp
    INTO bfx
    FROM bfbase.bnuexp
    WHERE coduex = p_coduex;

SET stmt = 'Create Alias Qtemp.blgtl00 For ' CONCAT BFX CONCAT '.blgtl00';
EXECUTE IMMEDIATE stmt;

SET stmt = 'Create Alias Qtemp.tlgtl01 For ' CONCAT BFX CONCAT '.tlgtl01';
EXECUTE IMMEDIATE stmt;


DECLARE GLOBAL TEMPORARY TABLE r LIKE bfbase.bnxlgp;
INSERT INTO Qtemp.r
    SELECT *
        FROM bfbase.bnxlgp
        WHERE cbasel = 'R'
              AND coduex = p_coduex;

DECLARE GLOBAL TEMPORARY TABLE t LIKE bfbase.bnxlgp;
INSERT INTO Qtemp.t
    SELECT *
        FROM bfbase.bnxlgp
        WHERE cbasel = 'T'
              AND coduex = p_coduex;

DECLARE GLOBAL TEMPORARY TABLE lr LIKE bfbase.bnlgtp;
INSERT INTO Qtemp.lr
    SELECT *
        FROM bfbase.bnlgtp
        WHERE coduex = p_coduex;

DECLARE GLOBAL TEMPORARY TABLE lt AS
            (SELECT l.*,
                    oprlgt
                    FROM Qtemp.blgtl00 l
                         LEFT JOIN Qtemp.tlgtl01
                             USING (nidlgt))
            WITH NO DATA;
INSERT INTO Qtemp.lt
    SELECT l.*,
           oprlgt
        FROM Qtemp.blgtl00 l
             LEFT JOIN Qtemp.tlgtl01
                 USING (nidlgt);   

SET STMT =
 'select ifnull(r.cidmcl, t.cidmcl), r.coduex coduexr, r.nbatim ' Concat
        'nbatimr, r.nescal nescalr, r.netage netager, r.nposit npositr, ' Concat
        't.coduex coduext, t.nbatim nbatimt, t.nescal nescalt, ' Concat
        't.netage netaget, t.nposit npositt, ' Concat
        'case when fill3a=''THE'' then ifnull(lt.trefcl, lr.trefcl) ' Concat
             'else ifnull(lr.trefcl, lt.trefcl) end ' Concat
             'AS customerReference, ' Concat
        'case when fill3a=''THE'' then ifnull(lt.templg, lr.templg) ' Concat
             'else ifnull(lr.templg, lt.templg) end AS location, ' Concat
        'case when fill3a=''THE'' then ifnull(lt.oprlgt, lr.oprlog) ' Concat
             'else ifnull(lr.oprlog, lt.oprlgt) end AS owner, ' Concat
        'case when fill3a=''THE'' then ifnull(lt.ctitre, lr.ctitre) ' Concat
             'else ifnull(lr.ctitre, lt.ctitre) end AS tenantTitle, ' Concat
        'case when fill3a=''THE'' then ifnull(lt.ooccup, lr.ooccup) ' Concat
             'else ifnull(lr.ooccup, lt.ooccup) end AS tenantName ' Concat
   'from Qtemp.r full join Qtemp.t on r.cidmcl=t.cidmcl left join  ' Concat
        'Qtemp.lr on (lr.nbatim, lr.nescal, lr.netage, lr.nposit) = ' Concat
        '(r.nbatim, r.nescal, r.netage, r.nposit) ' Concat
        'left join Qtemp.lt on ' Concat
        '(lt.nbatim, lt.nescal, lt.netage, lt.nposit) = ' Concat
        '(t.nbatim, t.nescal, t.netage, t.nposit) left join ' Concat
        'Bfbase.bnucop c on c.coduex=ifnull(r.coduex, t.coduex)';       
      
      PREPARE LGT_STMT FROM STMT; 
      
      
    
    OPEN LGT_CURSOR;
    
    SET RESULT SETS CURSOR LGT_CURSOR;
    

  END