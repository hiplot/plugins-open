var SE = (function(SE) {
  function f(alpha, beta) {
    var Z = {
      0.005: 2.576,
      0.01: 2.326,
      0.0125: 2.241,
      0.025: 1.96,
      0.05: 1.645,
      0.1: 1.282,
      0.15: 1.036,
      0.2: 0.842,
      0.25: 0.674,
      0.3: 0.524,
      0.4: 0.253,
      0.5: 0
    };
    return Math.pow(Z[alpha] + Z[beta], 2);
  }

  SE.power = {
    param: function(name) {
      var v = parseFloat($(":input#" + name).val());
      return v >= 0 ? v : NaN;
    },
    // Sample size per arm for binary outcome, superiority trial
    n_bin_sup: function(alpha, beta, p1, p2) {
      if (p1 === p2) {
        return "infinite";
      }
      return Math.ceil(
        f(alpha / 2, beta) *
          (p1 * (100 - p1) + p2 * (100 - p2)) /
          Math.pow(p1 - p2, 2)
      );
    },
    say_bin_sup: function(alpha, beta, p1, p2) {
      if (p1 === p2) {
        return;
      }
      var change = p2 > p1 ? "an increase" : "a decrease";
      return (
        2 * this.n_bin_sup(alpha, beta, p1, p2) +
        " patients are required to have a " +
        (100 - 100 * beta) +
        "% chance of detecting, as significant at the " +
        100 * alpha +
        "% level, " +
        change +
        " in the primary outcome measure from " +
        p1 +
        "% in the control group to " +
        p2 +
        "% in the experimental group."
      );
    },
    // Sample size per arm for binary outcome, equivalence trial
    n_bin_eqv: function(alpha, beta, p, d) {
      if (d === 0) {
        return "infinite";
      }
      return Math.ceil(2 * f(alpha, beta / 2) * p * (100 - p) / Math.pow(d, 2));
    },
    say_bin_eqv: function(alpha, beta, p, d) {
      if (d === 0) {
        return;
      }
      return (
        "If there is truly no difference between the standard and experimental treatment (" +
        p +
        "% in both groups), then " +
        2 * this.n_bin_eqv(alpha, beta, p, d) +
        " patients are required to be " +
        (100 - 100 * beta) +
        "% sure that the limits of a two-sided " +
        (100 - 100 * alpha * 2) +
        "% confidence interval " +
        "will exclude a difference between the standard and experimental group of more than " +
        d +
        "%"
      );
    },
    // Sample size per arm for binary outcome, non-inferiority trial
    n_bin_noninf: function(alpha, beta, ps, pe, d) {
      if (d === 0 || d <= ps - pe) {
        return "infinite";
      }
      return Math.ceil(
        f(alpha, beta) *
          (ps * (100 - ps) + pe * (100 - pe)) /
          Math.pow(ps - pe - d, 2)
      );
    },
    say_bin_noninf: function(alpha, beta, ps, pe, d) {
      var real_difference =
        "truly no difference between the standard and experimental treatment (" +
        ps +
        "% in both groups)";
      if (d === 0 || d <= ps - pe) {
        return;
      }
      if (ps > pe) {
        real_difference =
          "a true difference in favour of the standard treatment of " +
          (ps - pe) +
          "% (" +
          ps +
          "% vs " +
          pe +
          "%)";
      } else if (ps < pe) {
        real_difference =
          "a true difference in favour of the experimental treatment of " +
          (pe - ps) +
          "% (" +
          pe +
          "% vs " +
          ps +
          "%)";
      }
      return (
        "If there is " +
        real_difference +
        ", then " +
        2 * this.n_bin_noninf(alpha, beta, ps, pe, d) +
        " patients are required to be " +
        (100 - 100 * beta) +
        "% sure that the upper limit of a one-sided " +
        (100 - 100 * alpha) +
        "% confidence interval (or equivalently a " +
        (100 - 100 * alpha * 2) +
        "% two-sided confidence interval) " +
        "will exclude a difference in favour of the standard group of more than " +
        d +
        "%"
      );
    },
    // Sample size per arm for continuous outcome, superiority trial
    n_cont_sup: function(alpha, beta, m1, m2, sd) {
      if (m1 === m2) {
        return "infinite";
      }
      return Math.ceil(
        f(alpha / 2, beta) * 2 * Math.pow(sd, 2) / Math.pow(m1 - m2, 2)
      );
    },
    say_cont_sup: function(alpha, beta, m1, m2, sd) {
      if (m1 === m2) {
        return;
      }
      var change = m2 > m1 ? "an increase" : "a decrease";
      return (
        2 * this.n_cont_sup(alpha, beta, m1, m2, sd) +
        " patients are required to have a " +
        (100 - 100 * beta) +
        "% chance of detecting, as significant at the " +
        100 * alpha +
        "% level, " +
        change +
        " in the primary outcome measure from " +
        m1 +
        " in the control group to " +
        m2 +
        " in the experimental group."
      );
    },
    // Sample size per arm for continuous outcome, equivalence trial
    n_cont_eqv: function(alpha, beta, sd, d) {
      if (d === 0) {
        return "infinite";
      }
      return Math.ceil(
        2 * f(alpha, beta / 2) * Math.pow(sd, 2) / Math.pow(d, 2)
      );
    },
    say_cont_eqv: function(alpha, beta, sd, d) {
      if (d === 0) {
        return;
      }
      return (
        "If there is truly no difference between the standard and experimental treatment, then " +
        2 * this.n_cont_eqv(alpha, beta, sd, d) +
        " patients are required to be " +
        (100 - 100 * beta) +
        "% sure that the limits of a two-sided " +
        (100 - 100 * alpha * 2) +
        "% confidence interval " +
        "will exclude a difference in means of more than " +
        d +
        "."
      );
    },
    // Sample size per arm for continuous outcome, non-inferiority trial
    n_cont_noninf: function(alpha, beta, sd, d) {
      if (d === 0) {
        return "infinite";
      }
      return Math.ceil(2 * f(alpha, beta) * Math.pow(sd, 2) / Math.pow(d, 2));
    },
    say_cont_noninf: function(alpha, beta, sd, d) {
      if (d === 0) {
        return;
      }
      return (
        "If there is truly no difference between the standard and experimental treatment, then " +
        2 * this.n_cont_noninf(alpha, beta, sd, d) +
        " patients are required to be " +
        (100 - 100 * beta) +
        "% sure that the lower limit of a one-sided " +
        (100 - 100 * alpha) +
        "% confidence interval (or equivalently a " +
        (100 - 100 * alpha * 2) +
        "% two-sided confidence interval) " +
        "will be above the non-inferiority limit of -" +
        d +
        "."
      );
    },
    // sample size adjusted for cross-overs
    adjusted: function(n, c1, c2) {
      return Math.ceil(n * 1 / Math.pow(1 - c1 / 100 - c2 / 100, 2));
    }
  };

  return SE;
})(SE || {});
