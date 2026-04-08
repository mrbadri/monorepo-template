import type { JSX } from "react";

export default function HomePage(): JSX.Element {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-4 px-6 text-center">
      <h1 className="text-2xl font-semibold tracking-tight">خوش آمدید</h1>
      <p className="max-w-md text-muted-foreground text-sm leading-relaxed">
        این یک تمپلیت خالی است. از اینجا شروع کنید و صفحات و قابلیت‌های پروژهٔ جدید را اضافه کنید.
      </p>
    </main>
  );
}
