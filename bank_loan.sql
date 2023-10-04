																		    /* P193 GROUP 5*/
#-----------------------------------------------------------------------Bank_loan_of_a_customers-------------------------------------------------------------------------


CREATE DATABASE Bank_loan;

USE Bank_loan;

CREATE TABLE finance1(
    id INT PRIMARY KEY,  
    loan_amnt INT,  
    grade CHAR(1), 
    sub_grade CHAR(2), 
    home_ownership VARCHAR(10), 
    verification_status VARCHAR(20), 
    issue_d DATE, 
    loan_status VARCHAR(15),
    addr_state CHAR(2)
);

CREATE TABLE finance2(
    id INT, 
    revol_bal INT, 
    total_pymnt DECIMAL(10,4), 
    last_pymnt_d DATE, 
    FOREIGN KEY(id) REFERENCES finance1(id)
);




/*KPI1:
Year Wise Loan Amount Stats.*/
	 

     CREATE VIEW YearlyLoanStats AS
	 SELECT 
			year(issue_d) as Year,
			FORMAT(sum(loan_amnt) / 1000000, 0) as loan_amount_in_millions
     FROM 
			finance1 
     GROUP BY 
			year
     ORDER BY 
			year;
            

	 #USING VIEWS FOR KPI 1
     SELECT * FROM yearlyloanstats;



     
     
     
     /*KPI2:
     Grade And Subgrade Wise Revol_Bal*/
     
    CREATE VIEW GradeSubgrade_Revol_Bal AS 
	SELECT 
			f1.grade,
			f1.sub_grade,
			FORMAT(SUM(f2.revol_bal) / 1000000, 0) AS revol_bal_in_millions
	FROM 
			finance1 AS f1
	JOIN 
			finance2 AS f2 ON f2.id = f1.id
	GROUP BY 
			1,2
	ORDER BY 
			1,2;
            
	#USING VIEWS FOR KPI 2
    SELECT * FROM gradesubgrade_revol_bal;
    
     
     /*KPI3:
     Total Payment for Verified Status Vs Total Payment for Non Verified Status*/
     
     
     CREATE VIEW Total_Payment_Verification_Status_Wise AS
     SELECT 
			verification_status, 
			FORMAT(SUM(total_pymnt) / 1000000, 2) AS Total_payment_in_millions
     FROM 
			finance1 AS f1 
     INNER JOIN 
			finance2 AS f2 ON f1.id = f2.id
     WHERE 
			verification_status IN ( "Not Verified","Verified")
     GROUP BY 
			verification_status
	 ORDER BY 
			Total_payment_in_millions;
     
     #USING VIEWS For KPI 3
     SELECT * FROM Total_Payment_Verification_Status_Wise;
     
     /*KPI4:
     State wise and month wise loan status*/
     
     CREATE VIEW State_wise_and_month_wise_loan_status AS
     SELECT
			addr_state AS State,
			month(issue_d) as Month,
			MONTHNAME(issue_d) AS Month_Name, 
            COUNT(loan_status) AS Loan_Status
     FROM 
			finance1
     GROUP BY 
			State,
            Month,
            Month_Name
     ORDER BY 
			State,
            Month;
     
     #USING VIEWS FOR KPI 4
     SELECT * FROM State_wise_and_month_wise_loan_status;

     
     
     
     /*KPI5:
     Home ownership Vs last payment date stats*/
     
    CREATE VIEW  Home_ownership_Vs_last_payment_date_stats AS
	SELECT 
			f1.home_ownership, 
			YEAR(f2.last_pymnt_d) AS last_pymnt_year,
			COUNT(f1.id) AS countofid
	FROM 
			finance1 AS f1
	JOIN 
			finance2 AS f2 ON f2.id = f1.id
	GROUP BY 
			1,2
	ORDER BY 
			1,2;
    
    #USING VIEWS FOR KPI 5
    SELECT * FROM Home_ownership_Vs_last_payment_date_stats;
    
    
#--------------------------------------------------------------------------------Thank You------------------------------------------------------------------------------------------------    
																			 /* P193 GROUP 5*/