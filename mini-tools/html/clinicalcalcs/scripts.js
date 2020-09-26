// BMI function below 
const BMI = () => {
    let userWeight = Number(document.getElementById("weightinput").value);
    let userHeight = Number(document.getElementById("heightinput").value);
    let BMIresult = Math.floor(userWeight / (userHeight / 100 * userHeight / 100));
    
    if (BMIresult >= 0) {
    document.getElementById("bmiresult").innerHTML = "Your BMI is: " + BMIresult;
    } else {
        document.getElementById("bmiresult").innerHTML = "Seems to be an error";
    }
}

// CrCl function below
// Will need to capture 4 inputs

const CrCl = () => {
    // capture inputs
    let userAge = document.getElementById("ageinput").value;
    let userWeight2 = Number(document.getElementById("weightinput2").value);
    let userGender = document.getElementById("genderinput").value;
    let userSCR = Number(document.getElementById("sCrinput").value);

    // find two parts needed for CrCl calculation
    let calcone = (140 - userAge) * userWeight2;
    let calctwo = userSCR * 72;

    // final equation for CrCl, need to add female 0.85 factor below
    let finalCrCl = Math.floor(calcone / calctwo);
    let finalCrClf = Math.floor(calcone / calctwo) * 0.85;

    // if else statement to print M or F value
    if(userGender === "M") {
        document.getElementById("finalCrCl").innerHTML = "Since you're male, your CrCl is " + finalCrCl + " (mL/min)";
    } else if(userGender === "F") {
        document.getElementById("finalCrCl").innerHTML = "Since you're female, your CrCl is " + Math.floor(finalCrClf) + " (mL/min)";
    } else {
        // error message
        document.getElementById("finalCrCl").innerHTML = "Oops!, something went wrong."
    }

} 

// drug name side effects below
// as of 2/21/20, only works for sertraline
const drugSE = () => {
    let drugName = document.getElementById("userDrug").value;
    if(drugName === "sertraline") {
        document.getElementById("drugname").innerHTML = "Side effects of " + drugName + " include drowsiness, insomnia, and loss of appetite."
    } else {
        // error message
        document.getElementById("drugname").innerHTML = "Oops!, something went wrong."
    }

}