import functools

"""
Used to paginate API calls
Yields the results of the function and for each iteration increments the $key by $step

Expects the wrapper function to return the actual results (ie. not nested under another key)
"""
def paginate(key='page', step=1, default=1):

	def it(func):
		@functools.wraps(func)
		def wrapper(*args, **kwargs):
			this = args[0]
			this[f'___{key}___'] = default

			while True:
				kwargs[key] = this[f'___{key}___']
				results = func(*args, **kwargs)
				this[f'___{key}___'] += step

				empty = isinstance(results, list) and len(results) == 0 or \
								isinstance(results, dict) and len(results.keys()) == 0 or \
								not results

				if empty:
					break

				yield results
		return wrapper

	return it
