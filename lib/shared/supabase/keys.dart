const String SUPABASEKEY =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImViZ3psemVtcmFyZ2ZhaHdva3RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNzEyMjAsImV4cCI6MjA3MTk0NzIyMH0.M6UI6h5a0Z94WNeNb059JaejvFiVBfiHTt4rl2cC468";
const String SUPABASEURL = "https://ebgzlzemrargfahwokti.supabase.co";
const String SUPABASEURL_Dev = "https://obwbblumxlktdjtktkde.supabase.co";
const String clientIdForGoogleSignIn =
    '441901471963-q63onvc10n0naj5l8442bv7djprdes3e.apps.googleusercontent.com';

class SupabaseTables {
  static const String profiles = "profiles";
  static const String leadsList = "leadslist";
  static const String leadInfo = "lead_info";
  static const String courses = "courses";
  static const String jobProfiles = "job_profiles";
  static const String jobs = "jobs";
}

class SupabaseBuckets {
  static const String leadInfo = "lead_details";
  static const String resumes = "resumes";
}
