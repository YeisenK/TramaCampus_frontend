// The 6 Anáhuac campuses active in the current phase.
// Update this set when more campuses go live — no other code changes needed.
const kActiveCampusIds = {'UAO', 'UAXC', 'UAMN', 'UAMS', 'UAMT', 'MAYAB'};

// Undergraduate program codes start with 'B' (licenciatura) or 'I' (ingeniería).
// Master's use 'M' prefix; Doctorates use 'P'. Both are excluded from onboarding.
bool isUndergradProgramId(String id) =>
    id.startsWith('B') || id.startsWith('I');
