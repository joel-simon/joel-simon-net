import { makeNoise2D } from "open-simplex-noise";
import { addDays, addHours, differenceInDays, endOfDay } from "date-fns";

export function generateSchedule(
  startDate: Date,
  endDate: Date,
  amplitudeParams: { [key: string]: number },
  frequencyParams: { [key: string]: number }
) {
  const totalDays = differenceInDays(endDate, startDate);

  const noise2D = makeNoise2D(12345); // Fixed seed

  const timescales = {
    decade: 365.25 * 10,
    year: 365.25,
    month: 365.25 / 12,
    week: 7,
    day: 1,
  };

  const frequencies: number[] = [];
  const amplitudes: number[] = [];

  let maxAmplitude = 0;

  for (const [timescaleName, timescaleDuration] of Object.entries(timescales)) {
    const cycles = frequencyParams[timescaleName] || 1;
    const frequency = cycles / timescaleDuration;
    frequencies.push(frequency);

    const amplitude = amplitudeParams[timescaleName] || 0;
    amplitudes.push(amplitude);
    maxAmplitude += amplitude;
  }

  const schedule: { date: Date; productive: boolean; noiseValue: number }[] =
    [];

  for (let dayIndex = 0; dayIndex < totalDays; dayIndex++) {
    const currentDate = addDays(startDate, dayIndex);

    // Compute the noise value
    let noiseValue = 0.0;

    for (let i = 0; i < frequencies.length; i++) {
      const freq = frequencies[i];
      const amp = amplitudes[i];
      const t = dayIndex;
      noiseValue += amp * noise2D(t * freq, 0);
    }

    // Normalize the noise value to [0, 1]
    const normalizedNoise = (noiseValue + maxAmplitude) / (2 * maxAmplitude);

    // Decide productive or rest
    const threshold = 0.5;
    const productive = normalizedNoise >= threshold;

    schedule.push({
      date: currentDate,
      productive,
      noiseValue: normalizedNoise,
    });
  }

  return schedule;
}
// Generate a schedule for the hours in a day
export function generateHourlySchedule(
  date: Date,
  amplitudeParams: { [key: string]: number },
  frequencyParams: { [key: string]: number }
) {
  const totalHours = 24;

  const noise2D = makeNoise2D(12345); // Fixed seed

  const timescales = {
    day: 24,
    halfDay: 12,
    quarterDay: 6,
    hour: 1,
  };

  const frequencies: number[] = [];
  const amplitudes: number[] = [];

  let maxAmplitude = 0;

  for (const [timescaleName, timescaleDuration] of Object.entries(timescales)) {
    const cycles = frequencyParams[timescaleName] || 1;
    const frequency = cycles / timescaleDuration;
    frequencies.push(frequency);

    const amplitude = amplitudeParams[timescaleName] || 0;
    amplitudes.push(amplitude);
    maxAmplitude += amplitude;
  }

  const schedule: { date: Date; productive: boolean; noiseValue: number }[] =
    [];

  for (let hourIndex = 0; hourIndex < totalHours; hourIndex++) {
    const currentDate = addHours(date, hourIndex);

    // Compute the noise value
    let noiseValue = 0.0;

    for (let i = 0; i < frequencies.length; i++) {
      const freq = frequencies[i];
      const amp = amplitudes[i];
      const t = hourIndex;
      noiseValue += amp * noise2D(t * freq, 0);
    }

    // Normalize the noise value to [0, 1]
    const normalizedNoise = (noiseValue + maxAmplitude) / (2 * maxAmplitude);

    // Decide productive or rest
    const threshold = 0.5;
    const productive = normalizedNoise >= threshold;

    schedule.push({
      date: currentDate,
      productive,
      noiseValue: normalizedNoise,
    });
  }

  return schedule;
}
