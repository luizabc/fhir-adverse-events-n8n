CREATE TABLE adverse_events (
  id serial PRIMARY KEY,
  eventId text,
  eventText text,
  date timestamp,
  seriousness text,
  severity text,
  subjectReference text,
  birthDate date,
  gender text
);
