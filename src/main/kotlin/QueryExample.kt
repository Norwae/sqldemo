import de.codecentric.sqldemo.tables.references.*
import org.jooq.DSLContext
import org.jooq.impl.DSL
import java.sql.Timestamp
import java.time.LocalDate
import java.time.Period
import java.util.UUID

data class OverdueBook(val customerId: UUID, val bookTitles: List<String>)

fun overdueBooks(database: DSLContext): List<OverdueBook> {
    val overDueTable = DSL.table("overdue")
    val personID = DSL.field("personId", UUID::class.java)
    val threshold = DSL.field("threshold", LocalDate::class.java)
    val overdue = database
        .select(CUSTOMER.PERSON, DSL.now() -
            DSL.case_()
                .`when`(CUSTOMER.VIP, DSL.value(Period.ofWeeks(10)))
                .`when`(CUSTOMER.CUSTOMER_SINCE.lt(LocalDate.of(2019, 1, 1)), DSL.value(Period.ofMonths(1)))
                .`when`(CUSTOMER.CUSTOMER_SINCE.lt(DSL.cast(DSL.now() - DSL.value(Period.ofYears(2)), LocalDate::class.java)), DSL.value(Period.ofWeeks(4)))
                .else_(Period.ofDays(20))
                .cast(LocalDate::class.java)
        ).from(CUSTOMER)
        .asTable(overDueTable, personID, threshold)
    return database.select(PERSON.ID, DSL.arrayAgg(BOOK.TITLE))
        .from(PERSON)
        .join(LENDING).on(PERSON.ID.eq(LENDING.LENT_TO))
        .join(INVENTORY).on(INVENTORY.ID.eq(LENDING.INVENTORY_ITEM))
        .join(BOOK).on(BOOK.ISBN.eq(INVENTORY.BOOK))
        .join(overdue).on(PERSON.ID.eq(personID))
        .where(threshold.lt(LENDING.LENT_ON))
        .groupBy(PERSON.ID)
        .map {(id, titles) ->
            OverdueBook(id!!, titles!!.toList().requireNoNulls())
        }
}