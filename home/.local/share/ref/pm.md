def pm(func):
    """Python Post-Mortem Debugging Decorator"""
    import functools, pdb

    @functools.wraps(func)
    def func2(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            pdb.post_mortem(e.__traceback__)
            raise
    return func2
