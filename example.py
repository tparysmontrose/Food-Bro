import asyncio
from openai import AsyncOpenAI

# Set your API key here
api_key = ""

# Your organization and project IDs
organization = "org-7OvTe3rl75NgCwOK2CFmwptl"
project = "proj_CgwBIHtU1Rjf8UST9E5MXeOX"


client = AsyncOpenAI(
    # This is the default and can be omitted
    api_key=api_key,
)


system_prompt_part = """
    This is system prompt for the request which is used to generate personalised meal plan base on given parameters. 
"""


body_weigt = input("Enter your body weight [kg]: ")
height = input("Enter your height [cm]: ")
age = input("Enter your age: ")
gender = input("Enter your gender [Male or Female]: ")

bmi = int(body_weigt) / (int(height) / 100) ** 2

user_onboarding_part = f"""
    Use following data to personalise meal plan for user:
    - body weight: {body_weigt} kg
    - height: {height} cm
    - age: {age} years
    - BMI factor: {bmi} 
    - gender: {gender}
"""

food_preferences_input = input("Enter your food preferences: ")

food_preferences_part = f"""
    User has following food preferences:
    {food_preferences_input}

    Make sure you include these preferences in the meal plan.
"""

food_allergies_input = input("Enter food allergies: ")

food_allergies_part = f"""
    User has following food allergies:
    {food_allergies_input}

    Make sure you don't include these ingredients in the meal plan.
"""

sport_and_nutrition_input = input("Enter your sport and nutrition goals: ")

sport_and_nutrition_part = f"""
    User has following goals:
    {sport_and_nutrition_input}
    
    Make sure you include enough protein and carbs in the meal plan.
"""

summary_part = """
    Your instructions:

    Base on data above generate personalised meal plan for user.
    
    1. As an experienced meal planner, your task is to calculate the total calorie intake base on user's BMI,
    age, weight, height, gender, nutrition goals, sport goals and general. Make sure that the amount of
    calories fulfills user's needs and helps to achieve goals.
    
    2. Plan has to include:
    - 5 meals per day
    - calculated calories for each meal
    - be under or equal to caloric intake calculated base on BMI and factors above
    - be balanced and healthy, include enough protein, carbs and fats
    - take in account all the food preferences and allergies listed above 
    - take in account user's goals and make sure the meal plan will help to achieve them
    
    3.For each calculated meal execute the following prompt:

    As an experienced meal planner, your task is to calculate the total calorie content of the provided [meal].
    This calculation should take into account every ingredient used in the meal's preparation.
    To do this, you will need to break down the meal into its individual components,
    determine the portion size of each ingredient used, and then calculate the caloric value of each portion.
    The final outcome should be a detailed nutritional breakdown, including total calorie count.
    Remember to use reliable sources for the calorie values and be as accurate as possible.

    4. General requirements:
    - Meal plan has to be generated for 1 day.
    - print out only the plan, don't print any additional information
    - double check if you fulfilled all the requirements and preferences I listed in this prompt.
    - In the example below you can see how the final output should look like. This is just an example and you shouldn't
    copy paste these numbers 

    Example of answer: 
    Breakfast: scrambled eggs with spinach and avocado

    Ingredients: 
    - 2 eggs
    - 1/2 avocado
    - 1 cup spinach

    Preparation:
    - heat the pan
    - scramble the eggs
    - add spinach to the pan
    - serve with avocado

    Nutrition:
    - calories: 300
    - protein: 20g
    - carbs: 10g
    - fats: 15g

    =================================

    Lunch: quinoa salad with grilled chicken

    Ingredients:
    - 1/2 cup quinoa
    - 1/2 cup cherry tomatoes
    - 1/2 cucumber
    - 1/2 bell pepper
    - 100g grilled chicken

    Preparation:
    - cook quinoa
    - chop vegetables
    - grill chicken
    - mix all ingredients

    Nutrition:
    - calories: 400
    - protein: 25g
    - carbs: 30g
    - fats: 20g

    =================================

    Dinner: salmon with asparagus

    Ingredients:
    - 100g salmon
    - 1/2 lemon
    - 1/2 bunch asparagus

    Preparation:
    - heat the oven
    - season salmon
    - bake salmon
    - grill asparagus

    =================================

    Snack: apple with almond butter

    Ingredients:
    - 1 apple
    - 1 tbsp almond butter

    Preparation:
    - slice apple
    - serve with almond butter
    
    Nutrition:
    - calories: 200
    - protein: 10g
    - carbs: 10g
    - fats: 10g

    =================================

    .... and more or less meals, depends of requirements. That's just an example

    =================================

    Total nutrition:
    - calories: 1300
    - protein: 55g
    - carbs: 50g
    - fats: 35g

    =================================

    Groceries list:
    - 6 eggs
    - 1 avocado
    - 2 cups spinach
    - 1 cup quinoa
    - 1 cup cherry tomatoes
    - 1 cucumber
    - 1 bell pepper
    - 200g grilled chicken
    - 200g salmon
    - 1 lemon
    - 1 bunch asparagus
    - 4 apples
    - 4 tbsp almond butter

    =================================
"""

final_prompt = (
    system_prompt_part
    + user_onboarding_part
    + food_preferences_part
    + food_allergies_part
    + sport_and_nutrition_part
    + summary_part
)


async def main() -> None:
    chat_completion = await client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": final_prompt,
            }
        ],
        model="gpt-3.5-turbo",
    )
    print(chat_completion.choices[0].message.content)


asyncio.run(main())
