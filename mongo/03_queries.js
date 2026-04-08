use("D597Task2");

// Business question: Which grocery members make purchases most frequently?
// 1. Member loyalty analysis: customers with the most purchases
db.groceries.aggregate([
  { $sort: { Member_number: 1 } },
  { $group: { _id: "$Member_number", totalPurchases: { $sum: 1 } } },
  { $sort: { totalPurchases: -1 } },
  { $limit: 10 }
]);

// Business question: Which high-ranked cosmetics are suitable for combination skin?
// 2. High-ranked cosmetics suitable for combination skin
db.cosmetics.find({ Combination: 1 })
  .sort({ Rank: -1, Name: 1 })
  .limit(10);

// Business question: Which highly ranked products contain the trending ingredient Butylene Glycol?
// 3. Cosmetics containing a trending ingredient
db.cosmetics.find({
  Ingredients: { $regex: "Butylene Glycol", $options: "i" }
}).sort({ Rank: -1, Name: 1 });
