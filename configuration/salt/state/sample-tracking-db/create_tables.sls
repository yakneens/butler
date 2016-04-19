create_sample_locations_table:
  cmd.run:
    - user: postgres
    - name: psql -d pcawg_sample_tracking -c "CREATE TABLE sample_locations (sample_location_id serial PRIMARY KEY, donor_index integer REFERENCES pcawg_samples(index), normal_sample_location varchar(512), tumor_sample_location varchar(512), last_updated timestamp)"

