// src/native/haptics.js
import { Haptics, ImpactStyle } from '@capacitor/haptics';

export const tick = () => Haptics.impact({ style: ImpactStyle.Light });
export const win  = () => Haptics.notification({ type: 'SUCCESS' });
