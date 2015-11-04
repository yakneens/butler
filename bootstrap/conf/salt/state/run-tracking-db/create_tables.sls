create_sample_locations_table:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "CREATE TABLE sample_locations (sample_location_id serial PRIMARY KEY, donor_index integer REFERENCES pcawg_samples(index), normal_sample_location varchar(512), tumor_sample_location varchar(512), last_updated timestamp)"

create_runs_table:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "CREATE TABLE genotyping_runs (run_id serial PRIMARY KEY, donor_index serial REFERENCES pcawg_samples(index), sample_id text NOT NULL, run_status integer NOT NULL, created_date timestamp, run_start_date timestamp, run_end_date timestamp, last_updated_date timestamp, run_error_code integer)"

create_run_results_table:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "CREATE TABLE genotyping_run_results (run_result_id serial PRIMARY KEY, run_id serial REFERENCES genotyping_runs(run_id), result_location varchar(512), created_date timestamp, last_updated_date timestamp)"
