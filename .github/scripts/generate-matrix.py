import json, itertools, sys

exts = [e.strip() for e in sys.argv[1].split(',') if e.strip()]
vers = [v.strip() for v in sys.argv[2].split(',') if v.strip()]
matrix = [{'extension': e, 'version': v} for e, v in itertools.product(exts, vers)]
print(json.dumps(matrix))
