import type { JSX } from "react";

/**
 * Fallback document when navigation fails offline (Workbox / next-pwa fallbacks).
 */
export default function OfflinePage(): JSX.Element {
  return (
    <div
      className="min-h-screen flex flex-col items-center justify-center gap-4 bg-black px-6 text-center text-white"
      dir="rtl"
    >
      <p className="text-lg font-medium">اتصال اینترنت برقرار نیست</p>
      <p className="text-sm text-neutral-400 max-w-md">
        برای بارگذاری کامل برنامه، یک‌بار با اینترنت باز کنید تا محتوا ذخیره شود؛ سپس می‌توانید بدون
        شبکه از آن استفاده کنید.
      </p>
    </div>
  );
}
