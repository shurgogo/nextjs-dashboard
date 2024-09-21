import { inter } from "@/app/ui/fonts";
import "@/app/ui/global.css";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={`${inter.className} antialiased`}>{children}</body>
    </html>
  );
}

export const metadata = {
  metadataBase: new URL("http://localhost:3000"),
  title: {
    template: "%s | Acme Dashboard",
    default: "Acme Dashboard",
  },
  description: "a project to learn next js",
  openGraph: {
    title: "Acme",
    description: "open graph for this project",
    image: "/opengraph-image.jpg",
  },
};
