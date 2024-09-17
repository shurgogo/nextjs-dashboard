"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { z } from "zod";

const connectionPool = require("../../db");

const FormSchema = z.object({
  id: z.string(),
  customerId: z.string(),
  amount: z.coerce.number(),
  status: z.enum(["pending", "paid"]),
  date: z.string(),
});

const CreateInvoice = FormSchema.omit({ id: true, date: true });

export default async function createInvoice(formData: FormData) {
  const { customerId, amount, status } = CreateInvoice.parse({
    customerId: formData.get("customerId"),
    amount: formData.get("amount"),
    status: formData.get("status"),
  });
  // // 如果字段很多，用get显然很麻烦，可以用 entries
  // const { customerId, amount, status } = CreateInvoice.parse(
  //   Object.fromEntries(formData.entries())
  // );
  const amountInCents = amount * 100;
  const date = new Date().toISOString().split("T")[0];

  try {
    await connectionPool.query(`
      INSERT INTO invoices (customer_id, amount, status, date)
      VALUES ('${customerId}', '${amountInCents}', '${status}', '${date}')
    `);
  } catch (error) {
    console.error("Database Error:", error);
  }

  revalidatePath("/dashboard/invoices");
  redirect("/dashboard/invoices");
}

const UpdateInvoice = FormSchema.omit({ id: true, date: true });

export async function updateInvoice(id: string, formData: FormData) {
  const { customerId, amount, status } = UpdateInvoice.parse({
    customerId: formData.get("customerId"),
    amount: formData.get("amount"),
    status: formData.get("status"),
  });

  const amountInCents = amount * 100;

  console.log("status:", status);

  try {
    await connectionPool.query(`
      UPDATE invoices
      SET customer_id = '${customerId}', amount = '${amountInCents}', status = '${status}'
      WHERE id = '${id}'
    `);
  } catch (error) {
    console.error("Database Error:", error);
  }

  revalidatePath("/dashboard/invoices");
  redirect("/dashboard/invoices");
}

export async function deleteInvoice(id: string) {
  try {
    await connectionPool.query(`DELETE FROM invoices WHERE id = '${id}'`);
  } catch (error) {
    console.error("Database Error:", error);
  }
  revalidatePath("/dashboard/invoices");
}
