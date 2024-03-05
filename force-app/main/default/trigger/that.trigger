trigger CreditCheckPreQualification on Loan_Applicant__c (before insert, before update) {
    
    // Map to store credit score and financial history for each applicant
    Map<Id, ApplicantDetails> applicantDetailsMap = new Map<Id, ApplicantDetails>();
    
    // Retrieve credit score and financial history for all applicants
    for (Loan_Applicant__c applicant : Trigger.new) {
        applicantDetailsMap.put(applicant.Id, new ApplicantDetails(applicant.Credit_Score__c, applicant.Financial_History__c));
    }
    
    // Perform credit check and pre-qualification for each applicant
    for (Loan_Applicant__c applicant : Trigger.new) {
        ApplicantDetails applicantDetails = applicantDetailsMap.get(applicant.Id);
        
        // Perform credit check and determine loan amount and interest rate range
        Decimal loanAmount = performCreditCheck(applicantDetails.creditScore);
        Decimal interestRateRange = calculateInterestRateRange(applicantDetails.financialHistory);
        
        // Update applicant's pre-qualification details
        applicant.Pre_Qualified_Loan_Amount__c = loanAmount;
        applicant.Interest_Rate_Range__c = interestRateRange;
        applicant.Pre_Qualification_Outcome__c = determinePreQualificationOutcome(loanAmount, interestRateRange);
        applicant.Pre_Qualification_Explanation__c = generatePreQualificationExplanation(applicant.Pre_Qualification_Outcome__c);
    }
}

// Helper class to store credit score and financial history details
private class ApplicantDetails {
    Integer creditScore;
    String financialHistory;
    
    public ApplicantDetails(Integer creditScore, String financialHistory) {
        this.creditScore = creditScore;
        this.financialHistory = financialHistory;
    }
}

// Method to perform credit check and determine loan amount
private Decimal performCreditCheck(Integer creditScore) {
    // Perform credit check logic here and return loan amount based on credit score
    // Example: if credit score is >= 700, loan amount = $100,000; else loan amount = $50,000
    return (creditScore >= 700) ? 100000 : 50000;
}

// Method to calculate interest rate range based on financial history
private Decimal calculateInterestRateRange(String financialHistory) {
    // Calculate interest rate range logic here based on financial history
    // Example: if financial history is good, interest rate range = 3% - 5%; else interest rate range = 5% - 8%
    return (financialHistory.equals("Good")) ? 3.0 : 5.0;
}

// Method to determine pre-qualification outcome based on loan amount and interest rate range
private String determinePreQualificationOutcome(Decimal loanAmount, Decimal interestRateRange) {
    // Determine pre-qualification outcome logic here based on loan amount and interest rate range
    // Example: if loan amount >= $75,000 and interest rate range <= 4%, outcome = "Pre-Qualified"; else outcome = "Not Pre-Qualified"
    return (loanAmount >= 75000 && interestRateRange <= 4.0) ? "Pre-Qualified" : "Not Pre-Qualified";
}

// Method to generate pre-qualification explanation based on pre-qualification outcome
private String generatePreQualificationExplanation(String preQualificationOutcome) {
    // Generate pre-qualification explanation logic here based on pre-qualification outcome
    // Example: if outcome = "Pre-Qualified", explanation = "Congratulations! You are pre-qualified for a loan."; else explanation = "We regret to inform you that you are not pre-qualified for a loan."
    return (preQualificationOutcome.equals("Pre-Qualified")) ? "Congratulations! You are pre-qualified for a loan." : "We regret to inform you that you are not pre-qualified for a loan.";
}