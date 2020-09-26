$(function($) {
  module("Binary superiority calculator");

  test("Varying alpha", function() {
    equal(SE.power.n_bin_sup(0.01, 0.1, 20, 30), 551);
    equal(SE.power.n_bin_sup(0.025, 0.1, 20, 30), 460);
    equal(SE.power.n_bin_sup(0.05, 0.1, 20, 30), 389);
    equal(SE.power.n_bin_sup(0.1, 0.1, 20, 30), 317);
  });

  test("Varying beta", function() {
    equal(SE.power.n_bin_sup(0.05, 0.05, 10, 30), 98);
    equal(SE.power.n_bin_sup(0.05, 0.1, 10, 30), 79);
    equal(SE.power.n_bin_sup(0.05, 0.2, 10, 30), 59);
    equal(SE.power.n_bin_sup(0.05, 0.3, 10, 30), 47);
    equal(SE.power.n_bin_sup(0.05, 0.4, 10, 30), 37);
    equal(SE.power.n_bin_sup(0.05, 0.5, 10, 30), 29);
  });

  test("Varying p1", function() {
    equal(SE.power.n_bin_sup(0.05, 0.1, 5, 30), 44);
    equal(SE.power.n_bin_sup(0.05, 0.1, 20, 30), 389);
    equal(SE.power.n_bin_sup(0.05, 0.1, 50, 30), 121);
    equal(SE.power.n_bin_sup(0.05, 0.1, 80, 30), 16);
    equal(SE.power.n_bin_sup(0.05, 0.1, 95, 30), 7);
  });

  test("Varying p2", function() {
    equal(SE.power.n_bin_sup(0.05, 0.1, 30, 5), 44);
    equal(SE.power.n_bin_sup(0.05, 0.1, 30, 20), 389);
    equal(SE.power.n_bin_sup(0.05, 0.1, 30, 50), 121);
    equal(SE.power.n_bin_sup(0.05, 0.1, 30, 80), 16);
    equal(SE.power.n_bin_sup(0.05, 0.1, 30, 95), 7);
  });

  test("Pocock 1983", function() {
    equal(SE.power.n_bin_sup(0.05, 0.1, 90, 95), 579);
  });

  test("p1 and p2 the same means N=infinity", function() {
    equal(SE.power.n_bin_sup(0.05, 0.1, 95, 95), "infinite");
  });

  test("Adjusted for cross-overs", function() {
    equal(SE.power.adjusted(SE.power.n_bin_sup(0.05, 0.1, 90, 95), 10, 5), 802);
  });

  test("You could say string", function() {
    equal(
      SE.power.say_bin_sup(0.05, 0.1, 90, 95),
      "1158 patients are required to have a 90% chance of detecting, as significant at the 5% level, an increase in the primary outcome measure from 90% in the control group to 95% in the experimental group."
    );
  });

  module("Binary equivalance calculator");

  test("Varying alpha", function() {
    equal(SE.power.n_bin_eqv(0.01, 0.1, 30, 10), 663);
    equal(SE.power.n_bin_eqv(0.025, 0.1, 30, 10), 546);
    equal(SE.power.n_bin_eqv(0.05, 0.1, 30, 10), 455);
    equal(SE.power.n_bin_eqv(0.1, 0.1, 30, 10), 360);
  });

  test("Varying beta", function() {
    equal(SE.power.n_bin_eqv(0.05, 0.05, 40, 7), 1274);
    equal(SE.power.n_bin_eqv(0.05, 0.1, 40, 7), 1061);
    equal(SE.power.n_bin_eqv(0.05, 0.2, 40, 7), 840);
    equal(SE.power.n_bin_eqv(0.05, 0.3, 40, 7), 705);
    equal(SE.power.n_bin_eqv(0.05, 0.4, 40, 7), 606);
    equal(SE.power.n_bin_eqv(0.05, 0.5, 40, 7), 527);
  });

  test("Julious 2009, 12.1", function() {
    equal(SE.power.n_bin_eqv(0.025, 0.1, 70, 10), 546);
    equal(SE.power.n_bin_eqv(0.025, 0.1, 70, 20), 137);
    equal(SE.power.n_bin_eqv(0.025, 0.1, 90, 5), 936);
  });

  test("d = 0 means N=infinity", function() {
    equal(SE.power.n_bin_eqv(0.05, 0.1, 20, 0), "infinite");
  });

  test("You could say string", function() {
    equal(
      SE.power.say_bin_eqv(0.05, 0.1, 30, 10),
      "If there is truly no difference between the standard and experimental treatment (30% in both groups), then 910 patients are required to be 90% sure that the limits of a two-sided 90% confidence interval will exclude a difference between the standard and experimental group of more than 10%"
    );
  });

  module("Binary non-inferiority calculator");

  test("Varying alpha", function() {
    equal(SE.power.n_bin_noninf(0.01, 0.1, 30, 30, 10), 547);
    equal(SE.power.n_bin_noninf(0.025, 0.1, 30, 30, 10), 442);
    equal(SE.power.n_bin_noninf(0.05, 0.1, 30, 30, 10), 360);
    equal(SE.power.n_bin_noninf(0.1, 0.1, 30, 30, 10), 277);
  });

  test("Varying beta", function() {
    equal(SE.power.n_bin_noninf(0.05, 0.05, 40, 40, 7), 1061);
    equal(SE.power.n_bin_noninf(0.05, 0.1, 40, 40, 7), 840);
    equal(SE.power.n_bin_noninf(0.05, 0.2, 40, 40, 7), 606);
    equal(SE.power.n_bin_noninf(0.05, 0.3, 40, 40, 7), 461);
    equal(SE.power.n_bin_noninf(0.05, 0.4, 40, 40, 7), 353);
    equal(SE.power.n_bin_noninf(0.05, 0.5, 40, 40, 7), 266);
  });

  test("Donner, Example 3", function() {
    equal(SE.power.n_bin_noninf(0.1, 0.2, 80, 80, 10), 145);
  });

  test("Blackwelder, Table 3", function() {
    equal(SE.power.n_bin_noninf(0.05, 0.1, 90, 90, 20), 39);
    equal(SE.power.n_bin_noninf(0.05, 0.1, 60, 50, 20), 420);
  });

  test("Pocock, 1983", function() {
    equal(SE.power.n_bin_noninf(0.025, 0.2, 70, 70, 10), 330);
  });

  test("Pocock, 2003", function() {
    equal(SE.power.n_bin_noninf(0.025, 0.1, 85, 85, 15), 120);
  });

  test("When Ps not the same as Pe", function() {
    equal(SE.power.n_bin_noninf(0.05, 0.1, 30, 40, 10), 97);
    equal(SE.power.n_bin_noninf(0.05, 0.1, 40, 35, 10), 1603);
  });

  test("d = 0 or d <= (Ps - Pe) means N=infinity", function() {
    equal(SE.power.n_bin_noninf(0.05, 0.1, 20, 20, 0), "infinite");
    equal(SE.power.n_bin_noninf(0.05, 0.1, 20, 10, 10), "infinite");
    equal(SE.power.n_bin_noninf(0.05, 0.1, 20, 10, 9), "infinite");
  });

  test("You could say string", function() {
    equal(
      SE.power.say_bin_noninf(0.05, 0.1, 70, 70, 10),
      "If there is truly no difference between the standard and experimental treatment (70% in both groups), then 720 patients are required to be 90% sure that the upper limit of a one-sided 95% confidence interval (or equivalently a 90% two-sided confidence interval) will exclude a difference in favour of the standard group of more than 10%"
    );
    equal(
      SE.power.say_bin_noninf(0.05, 0.1, 75, 70, 10),
      "If there is a true difference in favour of the standard treatment of 5% (75% vs 70%), then 2726 patients are required to be 90% sure that the upper limit of a one-sided 95% confidence interval (or equivalently a 90% two-sided confidence interval) will exclude a difference in favour of the standard group of more than 10%"
    );
    equal(
      SE.power.say_bin_noninf(0.05, 0.1, 70, 75, 10),
      "If there is a true difference in favour of the experimental treatment of 5% (75% vs 70%), then 304 patients are required to be 90% sure that the upper limit of a one-sided 95% confidence interval (or equivalently a 90% two-sided confidence interval) will exclude a difference in favour of the standard group of more than 10%"
    );
  });

  module("Continuous superiority calculator");

  test("Varying alpha", function() {
    equal(SE.power.n_cont_sup(0.01, 0.1, 10, 20, 25), 187);
    equal(SE.power.n_cont_sup(0.025, 0.1, 10, 20, 25), 156);
    equal(SE.power.n_cont_sup(0.05, 0.1, 10, 20, 25), 132);
    equal(SE.power.n_cont_sup(0.1, 0.1, 10, 20, 25), 108);
  });

  test("Varying beta", function() {
    equal(SE.power.n_cont_sup(0.05, 0.05, 15, 20, 25), 650);
    equal(SE.power.n_cont_sup(0.05, 0.1, 15, 20, 25), 526);
    equal(SE.power.n_cont_sup(0.05, 0.2, 15, 20, 25), 393);
    equal(SE.power.n_cont_sup(0.05, 0.3, 15, 20, 25), 309);
    equal(SE.power.n_cont_sup(0.05, 0.4, 15, 20, 25), 245);
    equal(SE.power.n_cont_sup(0.05, 0.5, 15, 20, 25), 193);
  });

  test("Pocock 1983", function() {
    equal(SE.power.n_cont_sup(0.05, 0.05, 0, 0.5, 1.8), 337);
  });

  test("Julious 2004, 2.1.1", function() {
    equal(SE.power.n_cont_sup(0.05, 0.1, 0, 8, 40), 526);
  });

  test("m1 and m2 the same means N=infinity", function() {
    equal(SE.power.n_cont_sup(0.05, 0.1, 5, 5, 10), "infinite");
  });

  test("Adjusted for cross-overs", function() {
    equal(
      SE.power.adjusted(SE.power.n_cont_sup(0.05, 0.1, 0, 8, 40), 10, 15),
      936
    );
  });

  test("You could say string", function() {
    equal(
      SE.power.say_cont_sup(0.05, 0.1, 10, 20, 30),
      "380 patients are required to have a 90% chance of detecting, as significant at the 5% level, an increase in the primary outcome measure from 10 in the control group to 20 in the experimental group."
    );
    equal(
      SE.power.say_cont_sup(0.05, 0.1, 20, 15, 30),
      "1514 patients are required to have a 90% chance of detecting, as significant at the 5% level, a decrease in the primary outcome measure from 20 in the control group to 15 in the experimental group."
    );
  });

  module("Continuous equivalence calculator");

  test("Varying alpha", function() {
    equal(SE.power.n_cont_eqv(0.01, 0.1, 40, 10), 505);
    equal(SE.power.n_cont_eqv(0.025, 0.1, 40, 10), 416);
    equal(SE.power.n_cont_eqv(0.05, 0.1, 40, 10), 347);
    equal(SE.power.n_cont_eqv(0.1, 0.1, 40, 10), 275);
  });

  test("Varying beta", function() {
    equal(SE.power.n_cont_eqv(0.05, 0.05, 30, 10), 234);
    equal(SE.power.n_cont_eqv(0.05, 0.1, 30, 10), 195);
    equal(SE.power.n_cont_eqv(0.05, 0.2, 30, 10), 155);
    equal(SE.power.n_cont_eqv(0.05, 0.3, 30, 10), 130);
    equal(SE.power.n_cont_eqv(0.05, 0.4, 30, 10), 112);
    equal(SE.power.n_cont_eqv(0.05, 0.5, 30, 10), 97);
  });

  test("Julious 2004, 3.4.3", function() {
    equal(SE.power.n_cont_eqv(0.025, 0.1, 50, 10), 650);
  });

  test("d = 0 means N=infinity", function() {
    equal(SE.power.n_cont_eqv(0.05, 0.05, 30, 0), "infinite");
  });

  test("You could say string", function() {
    equal(
      SE.power.say_cont_eqv(0.05, 0.1, 30, 10),
      "If there is truly no difference between the standard and experimental treatment, then 390 patients are required to be 90% sure that the limits of a two-sided 90% confidence interval will exclude a difference in means of more than 10."
    );
  });

  module("Continuous non-inferiority calculator");

  test("Varying alpha", function() {
    equal(SE.power.n_cont_noninf(0.01, 0.1, 40, 10), 417);
    equal(SE.power.n_cont_noninf(0.025, 0.1, 40, 10), 337);
    equal(SE.power.n_cont_noninf(0.05, 0.1, 40, 10), 275);
    equal(SE.power.n_cont_noninf(0.1, 0.1, 40, 10), 211);
  });

  test("Varying beta", function() {
    equal(SE.power.n_cont_noninf(0.05, 0.05, 30, 10), 195);
    equal(SE.power.n_cont_noninf(0.05, 0.1, 30, 10), 155);
    equal(SE.power.n_cont_noninf(0.05, 0.2, 30, 10), 112);
    equal(SE.power.n_cont_noninf(0.05, 0.3, 30, 10), 85);
    equal(SE.power.n_cont_noninf(0.05, 0.4, 30, 10), 65);
    equal(SE.power.n_cont_noninf(0.05, 0.5, 30, 10), 49);
  });

  test("Julious 2004, 4.1.1", function() {
    equal(SE.power.n_cont_noninf(0.025, 0.1, 40, 10), 337);
  });

  test("d = 0 means N=infinity", function() {
    equal(SE.power.n_cont_noninf(0.05, 0.05, 30, 0), "infinite");
  });

  test("You could say string", function() {
    equal(
      SE.power.say_cont_noninf(0.05, 0.1, 70, 20),
      "If there is truly no difference between the standard and experimental treatment, then 420 patients are required to be 90% sure that the lower limit of a one-sided 95% confidence interval (or equivalently a 90% two-sided confidence interval) will be above the non-inferiority limit of -20."
    );
  });
});
