pragma circom 2.1.4;

template IsZero() {
  signal input in;
  signal output out;

  // we need to output
  // 1 if input is 0
  // 0 otherwise

  // Constraining this leads to a non-quadratic constraint error.
  // So it cannot be done directly. Without this constraint,
  // however, an attacker can replace this line with 
  // either 'inv <-- 1' (when in is 0), or
  // 'inv <-- 0' (when in is non-0), and then generate a proof
  // which will not be caught by our verifier.
  signal inv;
  inv <-- in != 0 ? 1 / in : 0;

  // With a substitution, this may evaluate to an incorrect value
  // And the verifier will not be able to detect the change (thus far).
  out <== -in * inv + 1;
  // However, with this line, such a change can be caught because
  // it forces that either of the two (or both) are zero
  // For example:
  // (1) If in is 5 and inv is set to 0 (incorrectly),
  // out will become 1 and the below constraint will fail.
  // (2) If in is 5 and inv is set to 1 (again incorrectly),
  // out will become -4 and the below constraint will fail
  // (3) If in is 5 and inv is set to 2 (incorrectly),
  // out will become -9 and the below constraint will fail.
  // (4) If in is 0 and inv is set to anything,
  // out will become 1 but this constraint will pass
  in * out === 0;
}

component main = IsZero();

/* INPUT = {
    "in": "0"
} */
