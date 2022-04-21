  - Love the "Falling Apples" intro. Goofy and engaging and I want to read more.
  - Straight into currying. Very nice refactor of a class using functions
    instead! The language continues to be fun. Enjoying it :)
  - You mention how mocks are "bad", but this codelab does not seem to propose
    any steps to verify the `PaymentSystem` is actually called? Yes, you have a
    charge object which can be tested, but where do you actually test the side
    effects occur as expected? In OOP, you would create a mock and pass it into
    the constructor. Then, you'd verify both the return value and that the
    `charge` method was called using something like Mockito. Is there a good
    place to discuss this? I feel like you pushed the side effects to the
    "edges" which is great, but perhaps didn't explain how to handle them other
    than in the `main` function which isn't super common in Flutter apps?
  - Time it took me to take the workshop and provide feedback: 1hr 12m
  - Complex topic, but overall I had a lot of fun taking this workshop. The flow
    was really nice in that it showed how to refactor some of these bits. 