import "./globals.css";

export const metadata = {
  title: "hello-word-18",
  description: "DB-backed Hello Word page"
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
