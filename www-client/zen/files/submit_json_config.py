#!/usr/bin/env python
#to run, write something along the lines of:python submit_json_config.py "/HDD_partitions/heavy_working_files/zen-browser", where the third argument depends on the caller (the ebuild will choose through $S)
import os
import sys
working_dir=sys.argv[1]
def create_the_code_to_execute():
	code_to_write= f"""
import sys
import importlib.util
spec = importlib.util.spec_from_file_location("write_json", f"{working_dir}/python/mozbuild/mozbuild/config_status.py")
module = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = module
spec.loader.exec_module(module)
module.config_status()
"""

def execute_code():
	code_to_write=create_the_code_to_execute()
	os.chdir(working_dir)
	os.system(f"{working_dir}/mach python -c {code_to_write}")
def main():
	execute_code()
if __name__ == "__main__":
	main()
