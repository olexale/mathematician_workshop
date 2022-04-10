// Look at these functions in the editor. Which ones are pure?
// (don't forget to check yourself by reviewing the solution)

num add3(num n) => n + 3;

const four = 4;
num add4(num n) => n + four;

num k = 0;
num addK(num n) => n + k;

num addM(num n, num m) {
  num result = n + m;
  return result;
}

num addMTimes(num n, num m, int times) {
  num result = n;
  for (var i = 0; i < times; i++) {
    n = addM(n, m);
  }
  return result;
}

void addM2(num n, num m) {
  print('$n + $m = ${addM(n, m)}');
}
