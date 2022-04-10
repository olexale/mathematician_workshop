// add3 is pure as it only depends on the input
// and doesn't change the environment.
num add3(num n) => n + 3;

// add4 is pure as it only depends on the input and a constant value
// and doesn't change the environment.
const four = 4;
num add4(num n) => n + four;

// addK is not pure as it depends on a global variable.
num k = 0;
num addK(num n) => n + k;

// addM is pure as it only depends on the input
// and doesn't change the environment.
num addM(num n, num m) {
  num result = n + m;
  return result;
}

// addMTimes is pure as it only depends on the input
// and addM functon, which is pure,
// and doesn't change the environment.
num addMTimes(num n, num m, int times) {
  num result = n;
  for (var i = 0; i < times; i++) {
    n = addM(n, m);
  }
  return result;
}

// addPrint is not pure as it depends on the output.
void addPrint(num n, num m) {
  print('$n + $m = ${addM(n, m)}');
}
